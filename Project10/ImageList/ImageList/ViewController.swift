//
//  ViewController.swift
//  ImageList
//
//  Created by Manish Charhate on 22/04/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    var images = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Image List"
        navigationController?.navigationBar.prefersLargeTitles = true

        let fileManager = FileManager.default
        guard let path = Bundle.main.resourcePath else {
            print("Couldn't create path.")
            return
        }
        guard let items = try? fileManager.contentsOfDirectory(atPath: path) else {
            print("Couldn't find items")
            return
        }
        for item in items {
            if item.hasPrefix("image") {
                images.append(item)
            }
        }
        images.sort()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            fatalError("Couldn't dequeue ImageCell")
        }

        cell.imageView.image = UIImage(named: images[indexPath.item])
        cell.imageView.layer.cornerRadius = 5
        cell.imageNameLabel.text = images[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imageViewerViewController = storyboard?.instantiateViewController(identifier: "ImageViewer") as? ImageViewerViewController {
            imageViewerViewController.selectedImage = images[indexPath.row]
            imageViewerViewController.title = "Image \(indexPath.row + 1) of \(images.count)"

            navigationController?.pushViewController(imageViewerViewController, animated: true)
        }
    }

}

