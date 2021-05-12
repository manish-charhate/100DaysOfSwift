//
//  ViewController.swift
//  WorldFlags
//
//  Created by Manish Charhate on 12/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var countryFlagData = [CountryFlagData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Country Flags"
        navigationController?.navigationBar.prefersLargeTitles = true

        // To hide unused empty cells
        tableView.tableFooterView = UIView()

        countryFlagData += [
            CountryFlagData(countryName: "estonia"),
            CountryFlagData(countryName: "france"),
            CountryFlagData(countryName: "germany"),
            CountryFlagData(countryName: "ireland"),
            CountryFlagData(countryName: "italy"),
            CountryFlagData(countryName: "monaco"),
            CountryFlagData(countryName: "nigeria"),
            CountryFlagData(countryName: "poland"),
            CountryFlagData(countryName: "russia"),
            CountryFlagData(countryName: "spain"),
            CountryFlagData(countryName: "uk"),
            CountryFlagData(countryName: "us")
        ]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryFlagData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryFlagCell", for: indexPath) as! CountryFlagCell
        cell.configure(with: countryFlagData[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "ImageViewerViewController") as? ImageViewerViewController else {
            print("Couldn't find view controller with given storyboardID")
            return
        }

        viewController.countryName = countryFlagData[indexPath.row].countryName
        navigationController?.pushViewController(viewController, animated: true)
    }
}
