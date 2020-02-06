//
//  SubmitReviewRepresentation.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/6/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

struct SubmitReviewRepresentation: Codable {
    var menu_item: String // Name of item from menu
    var item_price: Int // Price of item
    var item_rating: Int // Number rating of item
    var restaurant_id: Int // id given to restaurant
    var item_review: String // review of item
    var item_image_url: String // picture of item in jpg form
    var date_visited: Date // date of visitation
}
