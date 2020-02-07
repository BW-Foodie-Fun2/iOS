//
//  ReviewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

class ReviewController {
    
    var bearer: Bearer?
    
    var baseURL = URL(string: "https://foodiefun-1ca00.firebaseio.com/")!

    func createExperience(id: Int,
                          menu_item: String,
                        item_price: Int?,
                        item_rating: Int?,
                        restaurant_id: Int,
                         item_review: String?,
                        date_visited: String?) -> Review {
        let review = Review(id: id,
            menu_item: menu_item,
                            item_price: item_price ?? 0,
                            item_rating: item_rating ?? 0,
                            restaurant_id: restaurant_id,
                            item_review: item_review ?? "",
                            date_visited: date_visited ?? "",
                            context: CoreDataStack.shared.mainContext)
        CoreDataStack.shared.save()
        return review
    }
    
    func sendTaskToServer(review: Review, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            try CoreDataStack.shared.save()
//            request.httpBody = try JSONEncoder().encode([ReviewRepresentation].self)
        } catch {
            print("Error encoding review \(review): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error putting review to server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }

    func delete(review: Review) {
        CoreDataStack.shared.mainContext.delete(review)
        CoreDataStack.shared.save()
    }

    func fetchReviewsFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        guard let token = bearer?.token else {
            print("there is no bearer for fetchingMeals")
            return
        }
        
        let reviewURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: reviewURL)
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
            
            do {
                let decoder = JSONDecoder()
                let reviewRepresentation = try decoder.decode([ReviewRepresentation].self, from: data)
                self.updateReviews(with: reviewRepresentation)
            } catch {
                NSLog("Error decoding experience objects: \(error)")
                completion(error)
                return
            }
        }.resume()
    }

    func updateReview(review: Review,
                      id: Int?,
                      menu_item: String,
                      item_price: Int?,
                      item_rating: Int?,
                      restaurant_id: Int,
                      item_review: String?,
                      date_visited: String?) {
        review.id = Int16(id ?? 0)
        review.menu_item = menu_item
        review.item_price = Int16(item_price ?? 0)
        review.item_rating = Int16(item_rating ?? 0)
        review.restaurant_id = Int16(restaurant_id)
        review.item_review = item_review
        review.date_visited = date_visited
        
        CoreDataStack.shared.save()
    }

    func updateReviews(with representations: [ReviewRepresentation]) {
        let identifiersToFetch = representations.compactMap( {$0.id} )
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var reviewToCreate = representationsByID
        
        let context = CoreDataStack.shared.mainContext
        context.performAndWait {
            do {
                let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
                
                let existingReviews = try context.fetch(fetchRequest)
                
                for review in existingReviews {
                    let id = Int(review.id)
                    guard let representation = representationsByID[id] else { continue }
                    
                    review.menu_item = representation.menu_item
                    review.item_price = Int16(representation.item_price ?? 0)
                    review.item_rating = Int16(representation.item_rating ?? 0)
                    review.restaurant_id = Int16(representation.restaurant_id)
                    review.item_review = representation.item_review
                    review.date_visited = representation.date_visisted
                    
                    
                    reviewToCreate.removeValue(forKey: id)
                }
                
                for representation in reviewToCreate.values {
                    Review(reviewRepresentation: representation, context: context)
                }
                
                CoreDataStack.shared.save(context: context)
            } catch {
                print("Error fetching experiences from persistent store: \(error)")
            }
        }
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
            print("Experience representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try encoder.encode(reviewRepresentation)
        } catch {
            print("Error encoding experience representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error POSTing experience: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
}
