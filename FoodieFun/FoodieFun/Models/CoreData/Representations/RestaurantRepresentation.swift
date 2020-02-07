//
//  RestaurantRepresentation.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

struct ReviewRepresentation: Codable {
    var name: String
    var cuisineID: Int
    var location: String
    var hoursOfOperation: String
    var imgURL: String
    var createdBy: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case cuisineID = "cuisine_id"
        case location = "location"
        case hoursOfOperation = "hours_of_operation"
        case imgURL = "img_url"
        case createdBy = "created_by"
    }
}
