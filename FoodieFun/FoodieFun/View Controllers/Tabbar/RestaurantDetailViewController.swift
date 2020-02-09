//
//  RestaurantDetailViewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/9/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var cuisineNameTextField: UITextField!
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var dishPriceTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextView!
    
    var restaurantController: RestaurantController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
