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
        case id
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

/*
 Optional("[{\"id\":1,\"menu_item\":\"Mushroom Burger\",\"item_price\":8,\"item_rating\":5,\"item_review\":\"Nice well cooked shroom burger!\",\"restaurant_id\":1,\"reviewed_by\":\"ethan\",\"item_image_url\":\"https://www.simplyrecipes.com/wp-content/uploads/2011/06/grilled-beef-mushroom-burgers-verrtical-a-1800.jpg\",\"created_at\":\"2020-02-07 03:13:36\",\"updated_at\":\"2020-02-07 03:13:36\",\"date_visited\":\"2020-1-20\"},{\"id\":2,\"menu_item\":\"Cheesy Bean Burrito\",\"item_price\":7,\"item_rating\":3,\"item_review\":\"Okay burrito, too cheesy.\",\"restaurant_id\":3,\"reviewed_by\":\"kelly\",\"item_image_url\":\"https://images-gmi-pmc.edge-generalmills.com/074a3680-3adc-4aae-85f5-1e3a4f2caa34.jpg\",\"created_at\":\"2020-02-07 03:13:36\",\"updated_at\":\"2020-02-07 03:13:36\",\"date_visited\":\"2020-1-10\"},{\"id\":3,\"menu_item\":\"Cheesy eggs\",\"item_price\":6.5,\"item_rating\":4,\"item_review\":\"Yeah it was okay.\",\"restaurant_id\":2,\"reviewed_by\":\"josh\",\"item_image_url\":\"https://www.mrbreakfast.com/images/1077_spicy_cheesy_eggs.jpg\",\"created_at\":\"2020-02-07 03:13:36\",\"updated_at\":\"2020-02-07 03:13:36\",\"date_visited\":\"2020-1-05\"},{\"id\":4,\"menu_item\":\"burrito\",\"item_price\":6.5,\"item_rating\":4,\"item_review\":\"Yeah it was okay.\",\"restaurant_id\":2,\"reviewed_by\":\"iostest0\",\"item_image_url\":\"https://www.mrbreakfast.com/images/1077_spicy_cheesy_eggs.jpg\",\"created_at\":\"2020-02-09 03:20:03\",\"updated_at\":\"2020-02-09 03:20:03\",\"date_visited\":\"ffff\"},{\"id\":5,\"menu_item\":\"burrito\",\"item_price\":6.5,\"item_rating\":4,\"item_review\":\"Yeah it was okay.\",\"restaurant_id\":2,\"reviewed_by\":\"iostest0\",\"item_image_url\":\"https://www.mrbreakfast.com/images/1077_spicy_cheesy_eggs.jpg\",\"created_at\":\"2020-02-09 21:57:47\",\"updated_at\":\"2020-02-09 21:57:47\",\"date_visited\":\"ffff\"},{\"id\":6,\"menu_item\":\"burger\",\"item_price\":9.5,\"item_rating\":1,\"item_review\":\"Yeah it was okay.\",\"restaurant_id\":3,\"reviewed_by\":\"iostest0\",\"item_image_url\":\"https://www.mrbreakfast.com/images/1077_spicy_cheesy_eggs.jpg\",\"created_at\":\"2020-02-09 21:58:02\",\"updated_at\":\"2020-02-09 21:58:02\",\"date_visited\":\"ffff\"}]")
 */
