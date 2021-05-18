//
//  ViewController.swift
//  ShoppingList
//
//  Created by Manish Charhate on 18/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // MARK:- Properties

    private var itemList = [String]()

    // MARK:- Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ShoppingList"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToListButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearListButtonTapped))

        tableView.tableFooterView = UIView()
    }

    // MARK:- UITableView datasource and delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = itemList.first
        return cell
    }

    // MARK:- Private helpers

    @objc private func addToListButtonTapped() {
        let alertController = UIAlertController(title: "Add to list", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] _ in
            if let itemName = alertController?.textFields?[0].text {
                self?.itemList.insert(itemName, at: 0)
                self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }

    @objc private func clearListButtonTapped() {
        let alertController = UIAlertController(
            title: "Clear list",
            message: "Are you sure you want to delete all the items in the list?",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            self?.itemList.removeAll(keepingCapacity: true)
            self?.tableView.reloadData()
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }

}

