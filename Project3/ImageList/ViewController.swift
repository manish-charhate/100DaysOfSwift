//
//  ViewController.swift
//  ImageList
//
//  Created by Manish Charhate on 22/04/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
        cell.textLabel?.text = images[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let imageViewerViewController = storyboard?.instantiateViewController(identifier: "ImageViewer") as? ImageViewerViewController {
            imageViewerViewController.selectedImage = images[indexPath.row]
            imageViewerViewController.title = "Image \(indexPath.row + 1) of \(images.count)"

            navigationController?.pushViewController(imageViewerViewController, animated: true)
        }
    }

}

