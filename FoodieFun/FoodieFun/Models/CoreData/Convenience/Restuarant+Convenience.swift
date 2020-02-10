//
//  Restuarant+Convenience.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

extension Restaurant {
    var restaurantRepresentation: RestaurantRepresentation? {
        return RestaurantRepresentation(id: Int(id),
                                        name: name ?? "",
                                        cuisineID: Int(cuisineID),
                                        location: location ?? "",
                                        hoursOfOperation: hoursOfOperation ?? "",
                                        imgURL: imgURL ?? "",
                                        createdBy: createdBy ?? "",
                                        createdAt: createdAt,
                                        updatedAt: updatedAt)
    }
    
    convenience init(id: Int?,
                     name: String,
                     cuisineID: Int,
                     location: String,
                     hoursOfOperation: String,
                     imgURL: String,
                     createdBy: String,
                     createdAt: String?,
                     updatedAt: String?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = Int16(id ?? 0)
        self.name = name
        self.cuisineID = Int16(cuisineID)
        self.location = location
        self.hoursOfOperation = hoursOfOperation
        self.imgURL = imgURL
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    @discardableResult convenience init?(restaurantRepresentation: RestaurantRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = Int16(restaurantRepresentation.id ?? 0)
        self.name = restaurantRepresentation.name
        self.cuisineID = Int16(restaurantRepresentation.cuisineID)
        self.location = restaurantRepresentation.location
        self.hoursOfOperation = restaurantRepresentation.hoursOfOperation
        self.imgURL = restaurantRepresentation.imgURL
        self.createdBy = restaurantRepresentation.createdBy
        self.createdAt = restaurantRepresentation.createdAt
        self.updatedAt = restaurantRepresentation.updatedAt
    }
}
