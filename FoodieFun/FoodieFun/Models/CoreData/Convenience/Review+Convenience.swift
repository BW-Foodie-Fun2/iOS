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
        return ReviewRepresentation(id: Int(id),
                                    menuItem: menuItem ?? "",
                                    itemPrice: itemPrice,
                                    itemRating: Int(itemRating),
                                    itemReview: itemReview ?? "",
                                    restaurantID: Int(restaurantID),
                                    reviewedBy: reviewedBy,
                                    itemImageURL: itemImageURL ?? "",
                                    createdAt: createdAt,
                                    updatedAt: updatedAt,
                                    dateVisited: dateVisited ?? "")
    }
    
    convenience init(id: Int?,
                     menuItem: String,
                     itemPrice: Double,
                     itemRating: Int,
                     itemReview: String,
                     restaurant_id: Int,
                     reviewedBy: String?,
                     itemImageURL: String,
                     createdAt: String?,
                     updatedAt: String?,
                     dateVisited: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = Int16(id ?? 0)
        self.menuItem = menuItem
        self.itemPrice = itemPrice
        self.itemRating = Int16(itemRating)
        self.itemReview = itemReview
        self.restaurantID = Int16(restaurantID)
        self.reviewedBy = reviewedBy
        self.itemImageURL = itemImageURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.dateVisited = dateVisited
    }
    
    @discardableResult convenience init?(reviewRepresentation: ReviewRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
    }
}
