//
//  CountryFlagsData.swift
//  WorldFlags
//
//  Created by Manish Charhate on 13/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

struct CountryFlagData {

    let countryFlagImage: UIImage?
    let countryName: String

    init(countryName: String) {
        self.countryName = countryName
        self.countryFlagImage = UIImage(named: countryName)
    }
}
