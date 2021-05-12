//
//  CountryCell.swift
//  WorldFlags
//
//  Created by Manish Charhate on 12/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class CountryFlagCell: UITableViewCell {

    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var countryNameLabel: UILabel!

    func configure(with data: CountryFlagData) {
        countryNameLabel.text = data.countryName.uppercased()
        countryImageView.image = data.countryFlagImage
        countryImageView.layer.shadowOpacity = 0.9
        countryImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
