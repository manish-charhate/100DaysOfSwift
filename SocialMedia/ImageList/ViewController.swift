//
//  ViewController.swift
//  ImageList
//
//  Created by Manish Charhate on 22/04/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import LinkPresentation
import UIKit

class ViewController: UITableViewController {

    // MARK:- Properties

    var images = [String]()
    var linkMetadata: LPLinkMetadata? = nil

    // MARK:- Lifecycle methods

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
        images = items.compactMap { $0.hasPrefix("image") ? $0 : nil }.sorted()

        // Generate LPLinkMetadata in advanced to show preview-image of URL in share sheet.
        // Don't show `rightBarButtonItem` until the `LPLinkMetadata` is fetched.
        let metadataProvider = LPMetadataProvider()
        guard let appURL = URL(string: "https://www.hackingwithswift.com/100/22") else { return }
        metadataProvider.startFetchingMetadata(for: appURL) { [weak self] (metadata, error) in
            guard let strongSelf = self, error == nil else { return }
            strongSelf.linkMetadata = metadata

            // As `LPLinkMetadata` is available now, we can show `rightBarButtonItem`.
            DispatchQueue.main.async {
                strongSelf.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .action,
                    target: strongSelf,
                    action: #selector(strongSelf.actionButtonTapped))
            }
        }
    }

    // MARK:- UITableViewController methods

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

    // MARK:- Action Handler

    /**
     Challenge 2:

     Go back to project 1 and add a bar button item to the main view controller that recommends the app to other people.
     */
    @objc func actionButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true)
    }

}

extension ViewController: UIActivityItemSource {

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
