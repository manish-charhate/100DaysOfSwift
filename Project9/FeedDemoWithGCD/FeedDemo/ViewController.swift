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
    private var filteredPetitions = [Petition]()
    private lazy var filterButton = UIBarButtonItem(
        title: "Filter",
        style: .plain,
        target: self,
        action: #selector(filterButtonTapped))

    private lazy var clearFilterButton = UIBarButtonItem(
        title: "Clear Filter",
        style: .plain,
        target: self,
        action: #selector(clearFilterButtonTapped))

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Credits",
            style: .plain,
            target: self,
            action: #selector(creditsButtonTapped))

        navigationItem.leftBarButtonItem = filterButton
        let urlString = navigationController?.tabBarItem.tag == 0
        ? "https://www.hackingwithswift.com/samples/petitions-1.json"
        : "https://www.hackingwithswift.com/samples/petitions-2.json"

        performSelector(inBackground: #selector(fetchData), with: urlString)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.petitionBody
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(with: filteredPetitions[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    @objc private func fetchData(urlString: String) {
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(data: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    private func parse(data: Data) {
        let decoder = JSONDecoder()

        if let petitions = try? decoder.decode(Petitions.self, from: data) {
            self.petitions = petitions.results
            self.filteredPetitions = self.petitions
            performSelector(onMainThread: #selector(updateTableView), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    @objc private func updateTableView() {
        tableView.reloadData()
    }

    @objc private func showError() {
        let alertController = UIAlertController(
            title: "Error",
            message: "There was a problem loading the feed; please check your connection and try again",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }

    @objc private func creditsButtonTapped() {
        let alertController = UIAlertController(
            title: "This data comes from",
            message: "We The People API of the Whitehouse..",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }

    @objc private func filterButtonTapped() {
        let alertController = UIAlertController(
            title: "Filter",
            message: "Enter the text to filter the petitions list",
            preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(
            title: "Filter",
            style: .default,
            handler: { [weak self, weak alertController] _ in
                self?.performSelector(inBackground: #selector(self?.filterPetitionsList(_:)), with: alertController?.textFields?[0].text)
        }))
        alertController.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(alertController, animated: true)
    }

    @objc private func clearFilterButtonTapped() {
        filteredPetitions = petitions
        tableView.reloadData()
        navigationItem.leftBarButtonItem = filterButton
    }

    @objc private func filterPetitionsList(_ filterText: String?) {
        guard let filterText = filterText else { return }
        filteredPetitions = petitions.filter { $0.title.lowercased().contains(filterText.lowercased()) }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.navigationItem.leftBarButtonItem = self?.clearFilterButton
        }
    }

}

