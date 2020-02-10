//
//  RestaurantsTableViewCell.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/10/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class RestaurantsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantName: UILabel!
    
    var restaurant: Restaurant? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        restaurantName.text = restaurant?.name
    }
}
