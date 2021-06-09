//
//  ViewController.swift
//  KnownPeople
//
//  Created by Manish Charhate on 26/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPersonTapped))

        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let personCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Could not dequeue Person cell")
        }

        let person = people[indexPath.item]
        let imageURL = getDocumentDirectoryURL().appendingPathComponent(person.image)
        personCell.imageView.image = UIImage(contentsOfFile: imageURL.path)
        personCell.nameLabel.text = person.name

        personCell.imageView.layer.borderColor = UIColor.gray.cgColor
        personCell.imageView.layer.borderWidth = 2
        personCell.imageView.layer.cornerRadius = 3
        personCell.layer.cornerRadius = 7
        return personCell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]

        let alertController = UIAlertController(
            title: "Perform Action",
            message: nil,
            preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.rename(person: person)
        })

        alertController.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            self?.delete(person: person, at: indexPath)
        })

        present(alertController, animated: true)
    }

    @objc private func addPersonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        present(imagePickerController, animated: true)
    }

    private func rename(person: Person) {
        let alertController = UIAlertController(
            title: "Rename",
            message: nil,
            preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { [weak alertController, weak self] _ in
            guard let newName = alertController?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
            self?.saveData()
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }

    private func delete(person: Person, at indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "Delete \(person.name)?",
            message: "Are you sure you want to delete?",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Canfirm", style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.people.remove(at: indexPath.item)
            strongSelf.collectionView.deleteItems(at: [indexPath])
            self?.saveData()
        })
        present(alertController, animated: true)
    }

    private func saveData() {
        if let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(archivedData, forKey: "people")
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /**
     Writes selected image from library or camera and writes it to the app specific folder
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePathURL = getDocumentDirectoryURL().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePathURL)
        }

        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        saveData()

        dismiss(animated: true)
    }

    private func getDocumentDirectoryURL() -> URL {
        let pathURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return pathURLs[0]
    }
}
