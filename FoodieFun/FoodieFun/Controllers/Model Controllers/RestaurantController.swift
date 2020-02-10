//
//  RestaurantController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/9/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

class RestaurantController {
    
    typealias CompletionHanlder = (Error?) -> Void
    
    init() {
        fetchRestaurantsFromServer()
    }
    
    func fetchRestaurantsFromServer(completion: @escaping CompletionHanlder = { _ in }) {
        guard let token = bearer?.token else {
            print("There is no token for fetching reviews")
            return
        }
        
        let restaurantURL = baseURL.appendingPathComponent("api")
                                .appendingPathComponent("restaurants")
        print(restaurantURL)
        var request = URLRequest(url: restaurantURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(error)
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(error)
                return
            }
            print(String(data: data, encoding: String.Encoding.utf8))
            
            do {
                let decoder = JSONDecoder()
                let restaurantRepresentation = try decoder.decode([RestaurantRepresentation].self, from: data)
                self.updateRestaurant(with: restaurantRepresentation)
            } catch {
                NSLog("Error occured decoding reviews objects: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func updateRestaurant(with representations: [RestaurantRepresentation]) {
        let identifiersToFetch = representations.compactMap( { $0.id } )
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var restaurantsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id in %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        context.performAndWait {
            do {
                let exisitingRestaurant = try context.fetch(fetchRequest)
                
                for restaurant in exisitingRestaurant {
                    let id = Int(restaurant.id)
                    guard let representation = representationsByID[id] else { continue }
                    
                    restaurant.id = Int16(representation.id ?? 0)
                    restaurant.name = representation.name
                    restaurant.cuisineID = Int16(representation.cuisineID)
                    restaurant.location = representation.location
                    restaurant.hoursOfOperation = representation.hoursOfOperation
                    restaurant.imgURL = representation.imgURL
                    restaurant.createdBy = representation.createdBy
                    restaurant.createdAt = representation.createdAt
                    restaurant.updatedAt = representation.updatedAt
                    
                    restaurantsToCreate.removeValue(forKey: id)
                }
                
                for representation in restaurantsToCreate.values {
                    Restaurant(restaurantRepresentation: representation, context: context)
                }
                CoreDataStack.shared.save(context: context)
            } catch {
                print("Error fetching reviews from persistence store: \(error)")
            }
        }
    }
    
    func update(review: Review,
                           id: Int?,
                           menuItem: String,
                           itemPrice: Double,
                           itemRating: Int,
                           itemReview: String,
                           restaurantID: Int,
                           reviewedBy: String?,
                           itemImageURL: String,
                           createdAt: String?,
                           updatedAt: String?,
                           dateVisited: String) {
            review.id = Int16(id ?? 0)
            review.menuItem = menuItem
            review.itemPrice = itemPrice
            review.itemRating = Int16(itemRating)
            review.itemReview = itemReview
            review.restaurantID = Int16(restaurantID)
            review.reviewedBy = reviewedBy
            review.itemImageURL = itemImageURL
            review.createdAt = createdAt
            review.updatedAt = updatedAt
            review.dateVisited = dateVisited
            CoreDataStack.shared.save()
    }
    
    func saveToPersistenceStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving object context: \(error)")
        }
    }

    func createRestaurents(id: Int?,
                       menuItem: String,
                       itemPrice: Double,
                       itemRating: Int,
                       itemReview: String,
                       restaurantID: Int,
                       reviewedBy: String?,
                       itemImageURL: String,
                       createdAt: String?,
                       updatedAt: String?,
                       dateVisited: String) -> Review {
        let review = Review(id: id,
                            menuItem: menuItem,
                            itemPrice: itemPrice,
                            itemRating: itemRating,
                            itemReview: itemReview,
                            restaurant_id: restaurantID,
                            reviewedBy: reviewedBy,
                            itemImageURL: itemImageURL,
                            createdAt: createdAt,
                            updatedAt: updatedAt,
                            dateVisited: dateVisited,
                            context: CoreDataStack.shared.mainContext)
        post(review: review)
        saveToPersistenceStore()
        return review
    }

    func post(review: Review, completion: @escaping () -> Void = {}) {
        guard let token = bearer?.token else {
            completion()
            return
        }

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let requestURL = baseURL.appendingPathComponent("reviews")
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.post.rawValue

        guard let reviewRepresentation = review.reviewRepresentation else {
            print("Review Representation is nil")
            completion()
            return
        }

        do {
            request.httpBody = try encoder.encode(reviewRepresentation)
        } catch {
            print("Error ENCODING = Review Representation: \(error)")
            completion()
            return
        }

        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error POSTing reviews: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func delete(review: Review) {
        CoreDataStack.shared.mainContext.delete(review)
        CoreDataStack.shared.save()
    }
}
