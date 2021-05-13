//
//  ViewController.swift
//  MiniBrowser
//
//  Created by Manish Charhate on 14/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private let websites = ["apple.com", "linkedin.com", "google.com"]

    override func viewDidLoad() {
        title = "MiniBrowser"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteCell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let webViewController = storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController else {
            return
        }
        webViewController.allowedWebsites = websites
        webViewController.website = websites[indexPath.row]
        navigationController?.pushViewController(webViewController, animated: true)
    }

}
