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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
