//
//  ImageViewerViewController.swift
//  ImageList
//
//  Created by Manish Charhate on 23/04/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import LinkPresentation
import UIKit

class ImageViewerViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var linkMetadata: LPLinkMetadata?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))

        if let imageName = selectedImage,
            let imageToShow = UIImage(named: imageName) {
            imageView.image = imageToShow
            linkMetadata = LPLinkMetadata()
            linkMetadata?.title = imageName
            linkMetadata?.imageProvider = NSItemProvider(object: imageToShow)
            linkMetadata?.iconProvider = NSItemProvider(object: imageToShow)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareButtonTapped() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("Couldn't find image")
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [imageData, self], applicationActivities: [])
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true)
    }

}

/**
 Challenge 1:

 Try adding the image name to the list of items that are shared.
 The activityItems parameter is an array, so you can add strings and other things freely.
 Note: Facebook won’t let you share text, but most other share options will.
 */
extension ImageViewerViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        nil
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetadata
    }
}
