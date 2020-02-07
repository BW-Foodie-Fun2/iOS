//
//  AddDishViewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class AddDishViewController: UIViewController {
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var cuisineTypeTextField: UITextField!
    @IBOutlet weak var menuItemTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var shareExperienceButton: UIButton!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet var ratingLabel: UITextField!
    
    var reviewController: ReviewController?
    var reviewRepresentation: Review?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRestaurantName()
    }
    
    @IBAction func shareExperienceTapped(_ sender: Any) {
        guard let restuarantName = restaurantNameTextField.text,
            let menuName = menuItemTextField.text,
            let price = priceTextField.text,
            let rating = ratingLabel.text,
            let reviewRating = reviewTextView.text else { return }
        if let review = reviewRepresentation {
            reviewController?.createExperience(id: Int(0),
                                                menu_item: menuName,
                                                item_price: Int(price) ?? 0,
                                                item_rating: Int(rating) ?? 0,
                                                restaurant_id: Int(restuarantName) ?? 0,
                                                item_review: reviewRating,
                                                date_visited: review.date_visited)
        }
    }
    
    func setRestaurantName() {
        restaurantNameTextField.text = selectedRestaurantTitle
    }

}
