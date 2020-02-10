//
//  ReviewsTableViewCell.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var dateVisitedLabel: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var review: Review? {
        didSet {
            updateViews()
        }
    }
    
    var restaurant: Restaurant? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        menuName.text = review?.menuItem
        dateVisitedLabel.text = review?.dateVisited
        if let rating = review?.itemRating {
            ratingLabel.text = "Rating: \(rating)"
        }
    }
}
