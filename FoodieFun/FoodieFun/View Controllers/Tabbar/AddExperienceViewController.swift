//
//  AddDishViewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class AddExperienceViewController: ShiftableViewController {
    
    @IBOutlet weak var dishName: UITextField!
    @IBOutlet weak var dishPrice: UITextField!
    @IBOutlet weak var dishRating: UITextField!
    @IBOutlet weak var dishReview: UITextView!
    @IBOutlet weak var date: UITextField!
    
    var review: Review?
    var reviewController = ReviewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateViews() {
        guard isViewLoaded,
            let review = review else { return }
        dishName.text = review.menuItem
        dishPrice.text = "\(Double(review.itemPrice))"
        dishRating.text = "\(Int16(review.itemRating))"
        dishReview.text = review.itemReview
        date.text = review.dateVisited
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveReview()
        dismiss(animated: true, completion: nil)
    }
    
    func saveReview() {
        guard let dishName = dishName.text,
            !dishName.isEmpty,
            let dishPrice = dishPrice.text,
            !dishPrice.isEmpty,
            let dishRating = dishRating.text,
            !dishRating.isEmpty,
            let dishReview = dishReview.text,
            !dishReview.isEmpty,
            let dishDate = date.text,
            !dishDate.isEmpty else { return }
        print("INBETWEEN!")
        if let review = review {
            reviewController.update(review: review,
                                    id: 0,
                                    menuItem: dishName,
                                    itemPrice: Double(dishPrice) ?? 0,
                                    itemRating: Int(dishRating) ?? 0,
                                    itemReview: dishReview,
                                    restaurantID: Int(review.restaurantID),
                                    reviewedBy: review.reviewedBy ?? "",
                                    itemImageURL: review.itemImageURL ?? "",
                                    createdAt: review.createdAt,
                                    updatedAt: review.updatedAt,
                                    dateVisited: dishDate)
        } else {
        reviewController.createReviews(id: 0,
                                       menuItem: dishName,
                                       itemPrice: Double(dishPrice) ?? 0,
                                       itemRating: Int(dishRating) ?? 0,
                                       itemReview: dishReview,
                                       restaurantID: Int(review?.restaurantID ?? 0),
                                       reviewedBy: review?.reviewedBy ?? "",
                                       itemImageURL: review?.itemImageURL ?? "",
                                       createdAt: review?.createdAt,
                                       updatedAt: review?.updatedAt,
                                       dateVisited: dishDate)
        print("this is adding review")
        }
    }
}
