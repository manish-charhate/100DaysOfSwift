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
            title: "Rename person",
            message: nil,
            preferredStyle: .alert)

        alertController.addTextField()

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alertController.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: { [weak self, weak alertController] _ in
                guard let newName = alertController?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
        }))

        present(alertController, animated: true)
    }

    @objc private func addPersonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
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

        dismiss(animated: true)
    }

    private func getDocumentDirectoryURL() -> URL {
        let pathURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return pathURLs[0]
    }
}

