//
//  ReviewRepresentation.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

struct ReviewRepresentation: Codable {
    var id: Int?
    var menuItem: String
    var itemPrice: Double
    var itemRating: Int
    var itemReview: String
    var restaurantID: Int
    var reviewedBy: String?
    var itemImageURL: String
    var createdAt: String?
    var updatedAt: String?
    var dateVisited: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case menuItem = "menu_item"
        case itemPrice = "item_price"
        case itemRating = "item_rating"
        case itemReview = "item_review"
        case restaurantID = "restaurant_id"
        case reviewedBy = "reviewed_by"
        case itemImageURL = "item_image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case dateVisited = "date_visited"
    }
}
