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
    
    private let baseURL = URL(string: "https://foodiefunbw.herokuapp.com/")!
    var bearer: Bearer?
    
    func createRestaurant() {
        
    }
    
    func fetchRestaurantsFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        guard let token = bearer?.token else {
            print("There is no token for fetching restaurants")
            return
        }
        
        let restaurantURL = baseURL.appendingPathComponent("restaurants")
        
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
            
            do {
                let decoder = JSONDecoder()
                let restaurantRepresentation = try decoder.decode([RestaurantRepresentation].self, from: data)
                self.updateRestaurants(with: restaurantRepresentation)
            } catch {
                NSLog("Error occured decoding restaurant objects: \(error)")
                completion(error)
                return
            }
        }
        
    }
    
    func updateRestaurants(with representation: [RestaurantRepresentation]) {
        
    }

}
