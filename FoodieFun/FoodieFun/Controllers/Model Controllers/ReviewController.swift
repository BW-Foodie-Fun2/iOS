//
//  ReviewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://foodiefunbw.herokuapp.com")!

class ReviewController {
    
    typealias CompletionHanlder = (Error?) -> Void
    
    init() {
        fetchReviewFromServer()
    }
    
    func fetchReviewFromServer(completion: @escaping CompletionHanlder = { _ in }) {
        guard let token = bearer?.token else {
            print("There is no token for fetching reviews")
            return
        }
        
        let reviewURL = baseURL.appendingPathComponent("api")
                                .appendingPathComponent("reviews")
        print(reviewURL)
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
            print(String(data: data, encoding: String.Encoding.utf8))
            
            do {
                let decoder = JSONDecoder()
                let reviewRepresentation = try decoder.decode([ReviewRepresentation].self, from: data)
                self.updateReviews(with: reviewRepresentation)
            } catch {
                NSLog("Error occured decoding reviews objects: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func updateReviews(with representations: [ReviewRepresentation]) {
        let identifiersToFetch = representations.compactMap( { $0.id } )
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var reviewsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id in %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        context.performAndWait {
            do {
                let exisitingReviews = try context.fetch(fetchRequest)
                
                for review in exisitingReviews {
                    let id = Int(review.id)
                    guard let representation = representationsByID[id] else { continue }
                    
                    review.menuItem = representation.menuItem
                    review.itemPrice = representation.itemPrice
                    review.itemRating = Int16(representation.itemRating)
                    review.itemReview = representation.itemReview
                    review.restaurantID = Int16(representation.restaurantID)
                    review.reviewedBy = representation.reviewedBy
                    review.itemImageURL = representation.itemImageURL
                    review.createdAt = representation.createdAt
                    review.updatedAt = representation.updatedAt
                    review.dateVisited = representation.dateVisited
                    
                    reviewsToCreate.removeValue(forKey: id)
                }
                
                for representation in reviewsToCreate.values {
                    Review(reviewRepresentation: representation, context: context)
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

    func createReviews(id: Int?,
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
    
    func deleteReviewFromServer(review: Review, completion: @escaping CompletionHanlder = { _ in }) {
        let requstURL = baseURL.appendingPathComponent("api")
                                .appendingPathComponent("delete")
                                .appendingPathComponent("id")
        var request = URLRequest(url: requstURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)
            DispatchQueue.main.async {
                completion(error)
            }
        }.resume()
    }
}
