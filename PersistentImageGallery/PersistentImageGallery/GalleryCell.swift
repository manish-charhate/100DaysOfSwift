//
//  GalleryCell.swift
//  PersistentImageGallery
//
//  Created by Manish Charhate on 12/06/21.
//

import Foundation
import UIKit

class GalleryCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!

    func configure(with image: UIImage?, and caption: String) {
        photoView.image = image
        captionLabel.text = caption
    }
    
}
