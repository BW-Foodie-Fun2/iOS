//
//  ReviewRepresentation.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

struct ReviewRepresentation: Equatable, Codable {
    var id: Int?
    var menu_item: String
    var item_price: Int?
    var item_rating: Int?
    var restaurant_id: Int
    var item_review: String?
    var date_visisted: String?
}

