//
//  ViewController.swift
//  FeedDemo
//
//  Created by Manish Charhate on 19/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = navigationController?.tabBarItem.tag == 0
        ? "https://www.hackingwithswift.com/samples/petitions-1.json"
        : "https://www.hackingwithswift.com/samples/petitions-2.json"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(data: data)
                return
            }
        }
        showError()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.petitionBody
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(with: petitions[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    private func parse(data: Data) {
        let decoder = JSONDecoder()

        if let petitions = try? decoder.decode(Petitions.self, from: data) {
            self.petitions = petitions.results
            tableView.reloadData()
        }
    }

    private func showError() {
        let alertController = UIAlertController(
            title: "Error",
            message: "There was a problem loading the feed; please check your connection and try again",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }

}

