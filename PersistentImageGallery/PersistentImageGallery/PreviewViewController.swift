//
//  PreviewViewController.swift
//  PersistentImageGallery
//
//  Created by Manish Charhate on 13/06/21.
//

import Foundation
import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextField!

    var capturedImage: UIImage?
    var caption: String?
    var dataManager: DataManager?

    override func viewDidLoad() {
        guard let capturedImage = capturedImage else {
            dismiss(animated: true)
            return
        }
        imageView.image = capturedImage
        captionTextView.delegate = self
        captionTextView.returnKeyType = .done
    }
}

extension PreviewViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        caption = textField.text
        dataManager?.addNewModel(with: capturedImage, caption: caption)
        dismiss(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
