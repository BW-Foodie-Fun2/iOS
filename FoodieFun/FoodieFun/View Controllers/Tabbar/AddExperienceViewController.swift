//
//  AddDishViewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class AddExperienceViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dishName: UITextField!
    @IBOutlet weak var dishPrice: UITextField!
    @IBOutlet weak var dishRating: UITextField!
    @IBOutlet weak var dishReview: UITextView!
    @IBOutlet weak var date: UITextField!
    
//    var review: Review?
//    var reviewController: ReviewController?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateViews()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if review == nil {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReview))
//        }
//    }
//    
//    func updateViews() {
//        guard isViewLoaded else { return }
//        
//        dishName.text = review?.menuItem ?? ""
//    }
//    
//    @objc func saveReview() {
//        guard let dishName = dishName.text,
//            !dishName.isEmpty,
//            let reviewController = reviewController else { return }
//        if let review = review {
//            reviewController.update(review: review,
//                                    id: id,
//                                    menuItem: , itemPrice: <#T##Double#>, itemRating: <#T##Int#>, itemReview: <#T##String#>, restaurantID: <#T##Int#>, reviewedBy: <#T##String?#>, itemImageURL: <#T##String#>, createdAt: <#T##String?#>, updatedAt: <#T##String?#>, dateVisited: <#T##String#>)
//        }
//    }
}
