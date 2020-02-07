//
//  Review+Convience.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData


extension Review {

    var reviewRepresentation: ReviewRepresentation? {
        guard let menuItem = menu_item,
            let itemReview = item_review else { return nil }

        return ReviewRepresentation(id: Int(id),
                                    menu_item: menuItem,
                                    item_price: Int(item_price),
                                    item_rating: Int(item_rating),
                                    restaurant_id: Int(restaurant_id),
                                    item_review: itemReview,
                                    date_visisted: date_visited)
    }

    convenience init(id: Int? = nil,
                     menu_item: String,
                     item_price: Int,
                     item_rating: Int,
                     restaurant_id: Int,
                     item_review: String,
                     date_visited: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.menu_item = menu_item
        self.item_price = Int16(item_price)
        self.item_rating = Int16(item_rating)
        self.restaurant_id = Int16(restaurant_id)
        self.item_review = item_review
        self.date_visited = date_visited
    }

    @discardableResult convenience init?(reviewRepresentation: ReviewRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
    }

}
