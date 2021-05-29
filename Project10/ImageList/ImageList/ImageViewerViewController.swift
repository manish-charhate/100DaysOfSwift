//
//  ImageViewerViewController.swift
//  ImageList
//
//  Created by Manish Charhate on 23/04/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        if let imageToShow = selectedImage {
            imageView.image = UIImage(named: imageToShow)
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

}
