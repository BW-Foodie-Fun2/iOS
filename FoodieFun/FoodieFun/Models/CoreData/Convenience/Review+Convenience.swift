//
//  Review+Convience.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

/*
 struct ReviewRepresentation: Equatable, Codable {
 var id: String
 var menuItem: String
 var itemPrice: Double?
 var itemRating: Int?
 var restaurantID: Int?
 var itemReview: String?
 */

/*
 name - menu item / restaurant item
 notes - review
 segment - rating
 */

//enum Rating: String {
//    case one
//    case two
//    case three
//    case four
//    case five
//
//    static var allRatings: [Rating] {
//        return [.one, .two, .three, .four, .five]
//    }
//}
//
//extension Review {
//
//    var reviewRep: ReviewRepresentation? {
//        guard let review = review,
//            let rating = rating else {
//                return nil
//        }
//
//        return ReviewRepresentation(id: id?.uuidString, review: review, name: name, rating: rating)
//
//    }
//
//    @discardableResult convenience init(name: String,
//                                        review: String? = nil,
//                                        rating: Rating = .three,
//                                        id: UUID = UUID(),
//                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        self.init(context: context)
//        self.name = name
//        self.review = review
//        self.rating = rating.rawValue
//    }
//
//    @discardableResult convenience init?(reviewRepresentation: ReviewRepresentation,
//                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        guard let rating = Rating(rawValue: reviewRepresentation.rating),
//            let idString = reviewRepresentation.id,
//            let id = UUID(uuidString: idString) else {
//                return nil
//        }
//        self.init(name: reviewRepresentation.name ?? "",
//                  review: reviewRepresentation.review,
//                  rating: rating,
//                  id: id,
//                  context: context)
//    }
//}


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
