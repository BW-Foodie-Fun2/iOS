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
    
    var review: Review? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        menuName.text = review?.menu_item
        dateVisitedLabel.text = review?.date_visited
    }
    
}
