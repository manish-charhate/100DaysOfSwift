//
//  ImageViewerViewController.swift
//  WorldFlags
//
//  Created by Manish Charhate on 12/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import LinkPresentation
import UIKit

class ImageViewerViewController: UIViewController {

    var countryName: String?
    @IBOutlet var imageView: UIImageView!
    private var linkMetadata: LPLinkMetadata?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOpacity = 0.3

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonTapped))

        if let selectedCountryName = countryName,
            let countryFlagImage = UIImage(named: selectedCountryName) {
            title = selectedCountryName.uppercased()
            imageView.image = countryFlagImage
            linkMetadata = LPLinkMetadata()
            linkMetadata?.title = "Hey! Check out the flag of \(selectedCountryName.uppercased())"
            linkMetadata?.iconProvider = NSItemProvider(object: countryFlagImage)
        }
    }

    @objc private func shareButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

}

extension ImageViewerViewController: UIActivityItemSource {

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetadata
    }

}
