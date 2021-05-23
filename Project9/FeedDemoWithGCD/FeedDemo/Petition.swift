//
//  Petition.swift
//  FeedDemo
//
//  Created by Manish Charhate on 19/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import Foundation

struct Petition: Codable {

    enum CodingKeys: String, CodingKey {
        case title, signatureCount

        // Map the JSON key "body" to the swift property name "petitionBody"
        case petitionBody = "body"
    }

    let title: String
    let petitionBody: String
    let signatureCount: Int
}
