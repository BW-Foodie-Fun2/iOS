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
    
    var restaurant: Restaurant?
    var restaurantController: RestaurantController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if restaurant == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveRestaurant))
        }
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = restaurant?.name ?? "Create Restaurant"
        restaurantNameTextField.text = restaurant?.name ?? ""
        
    }
    
    @objc func saveRestaurant() {
        guard let restaurantName = restaurantNameTextField.text,
            !restaurantName.isEmpty,
            let restaurantController = restaurantController else {
                return
        }
//        restaurantController.post(restaurant: restaurant)
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
