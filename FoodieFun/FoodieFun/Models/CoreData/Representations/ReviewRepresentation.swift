//
//  ReviewRepresentation.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/6/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

struct ReviewRepresentation: Codable {
    var menuItem: String
    var itemPrice: Double
    var itemRating: Int
    var restaurantID: Int
    var itemReview: String
    var itemImageURL: String
    var dateVisited: String

    enum CodingKeys: String, CodingKey {
        case menuItem = "menu_item"
        case itemPrice = "item_price"
        case itemRating = "item_rating"
        case restaurantID = "restaurant_id"
        case itemReview = "item_review"
        case itemImageURL = "item_image_url"
        case dateVisited = "date_visited"
    }
}
