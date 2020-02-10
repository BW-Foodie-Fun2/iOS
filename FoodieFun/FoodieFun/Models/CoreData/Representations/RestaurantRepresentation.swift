//
//  RestaurantRepresentation.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/8/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

struct RestaurantRepresentation: Codable {
    var id: Int?
    var name: String
    var cuisineID: Int
    var location: String
    var hoursOfOperation: String
    var imgURL: String
    var createdBy: String
    var createdAt: String?
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case cuisineID = "cuisine_id"
        case location = "location"
        case hoursOfOperation = "hours_of_operation"
        case imgURL = "img_url"
        case createdBy = "created_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
