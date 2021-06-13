//
//  ViewController.swift
//  PersistentImageGallery
//
//  Created by Manish Charhate on 12/06/21.
//

import UIKit

class ViewController: UITableViewController {

    lazy var dataManager = DataManager(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "My Image Gallery"
        tableView.tableFooterView = UIView()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        let model = dataManager.models[indexPath.row]
        let image = dataManager.extractImage(with: model.imageName)
        cell.configure(with: image, and: model.caption)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataManager.models[indexPath.row]
        guard let image = dataManager.extractImage(with: model.imageName) else {
            return
        }
        let viewController = ImageViewerViewController(image)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func addNewPhoto() {
        let alertController = UIAlertController(title: "Select option", message: "From where you want to select a photo?", preferredStyle: .alert)

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(
                                        title: "Camera",
                                        style: .default,
                                        handler: { [weak self] _ in
                                            imagePickerController.sourceType = .camera
                                            imagePickerController.showsCameraControls = true
                                            self?.present(imagePickerController, animated: true)
                                        }))
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(UIAlertAction(
                                        title: "Photo Library",
                                        style: .default,
                                        handler: { [weak self] _ in
                                            imagePickerController.sourceType = .photoLibrary
                                            self?.present(imagePickerController, animated: true)
                                        }))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let capturedImage = info[.editedImage] as? UIImage,
              let storyboard = storyboard else {
            return
        }

        guard let previewViewController = storyboard.instantiateViewController(identifier: "PreviewViewController") as? PreviewViewController else {
            return
        }
        previewViewController.capturedImage = capturedImage
        previewViewController.dataManager = dataManager

        // This is important, otherwise after tapping "Use photo" button the app simply freezes.
        picker.dismiss(animated: true)

        present(previewViewController, animated: true)
    }

    private func getDocumentsDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
}

extension ViewController: DataManagerDelegate {

    func modelsDidUpdate() {
        tableView.reloadData()
    }
}
