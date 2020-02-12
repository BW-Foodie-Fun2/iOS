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
    
    let baseURL = URL(string: "https://foodiefunbw.herokuapp.com")!
    
    func fetchRestaurantsFromServer(completion: @escaping CompletionHanlder = { _ in }) {
        guard let token = bearer?.token else {
            print("There is no token for fetching restaurant")
            return
        }
        
        let restaurantURL = baseURL.appendingPathComponent("api")
                                    .appendingPathComponent("restaurants")
        
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
                NSLog("Error occured decoding restaurant objects: \(error)")
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
                print("Error fetching restaurant from persistence store: \(error)")
            }
        }
    }
    
    func update(restaurant: Restaurant,
                id: Int?,
                name: String,
                cuisineID: Int,
                location: String,
                hoursOfOperation: String,
                imgURL: String,
                createdBy: String?,
                createdAt: String?,
                updatedAt: String) {
        
        restaurant.id = Int16(id ?? 0)
        restaurant.name = name
        restaurant.cuisineID = Int16(cuisineID)
        restaurant.location = location
        restaurant.hoursOfOperation = hoursOfOperation
        restaurant.imgURL = imgURL
        restaurant.createdBy = createdBy
        restaurant.createdAt = createdAt
        restaurant.updatedAt = updatedAt
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
                           name: String,
                           cuisineID: Int,
                           location: String,
                           hoursOfOperation: String,
                           imgURL: String,
                           createdBy: String?,
                           createdAt: String?,
                           updatedAt: String) {
        let restaurant = Restaurant(id: id,
                                    name: name,
                                    cuisineID: cuisineID,
                                    location: location,
                                    hoursOfOperation: hoursOfOperation,
                                    imgURL: imgURL,
                                    createdBy: createdBy ?? "",
                                    createdAt: createdAt,
                                    updatedAt: updatedAt,
                                    context: CoreDataStack.shared.mainContext)
        post(restaurant: restaurant)
        saveToPersistenceStore()
    }
    
    func post(restaurant: Restaurant, completion: @escaping () -> Void = {}) {
        guard let token = bearer?.token else {
            completion()
            return
        }
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let requestURL = baseURL.appendingPathComponent("api").appendingPathComponent("restaurants")
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.post.rawValue
        
        guard let restaurantRepresentation = restaurant.restaurantRepresentation else {
            print("Restaurant Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try encoder.encode(restaurantRepresentation)
        } catch {
            print("Error ENCODING = Restaurant Representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error POSTing restaurant: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func delete(restaurant: Restaurant) {
        CoreDataStack.shared.mainContext.delete(restaurant)
        CoreDataStack.shared.save()
    }
    
    func deleteRestaurantFromServer(restaurant: Restaurant, completion: @escaping CompletionHanlder = { _ in }) {
        guard let token = bearer?.token else {
            completion(nil)
            return
        }
        let requstURL = baseURL.appendingPathComponent("api")
                                .appendingPathComponent("restaurants")
                                .appendingPathComponent("\(restaurant.id)")
        var request = URLRequest(url: requstURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)
            DispatchQueue.main.async {
                completion(error)
            }
        }.resume()
    }
}
