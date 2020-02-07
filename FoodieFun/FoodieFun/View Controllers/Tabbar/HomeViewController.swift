//
//  HomeViewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

public var selectedRestaurantTitle: String = ""

class HomeViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foodSearchMapView: MKMapView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var categoriesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var navigateToRestaurantButton: UIButton!
    @IBOutlet weak var selectRestaurantButton: UIButton!
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    
    var searchedTextString: String = ""
    var latitudeDelta: Double = 0.3
    var longitudeDelta: Double = 0.3
    var latitudinalMeters: Double = 2900.0
    var longitudinalMeters: Double = 2900.0
    var arrayOfResutls: [MKMapItem] = []
    var categories: [MKPointOfInterestCategory] = [.restaurant]
    var userCurrentLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var navigatoToLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var locationManager:CLLocationManager!
    let searchRadius: CLLocationDistance = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }
    
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        if let searchedText: String = searchBar.text {
            foodSearchMapView.removeAnnotations(foodSearchMapView.annotations)
            searchedTextString = searchedText
            searchInMap()
            
            searchBar.resignFirstResponder()
        }
    }
        
    // Search in map using given string from searchBar
    func searchInMap() {
        
        // Create request
        let request = MKLocalSearch.Request()
        // Including array of MLPointOfInterestCategory
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: categories)
        request.naturalLanguageQuery = searchedTextString
        
        // Create span
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta,
                                    longitudeDelta: longitudeDelta)
        
        // Request region
        request.region = MKCoordinateRegion(center: userCurrentLocation.coordinate,
                                            span: span)
        // Run search
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            if response == nil {
                self.messageErrorNoResults()
            }
            
            if let response = response {
            for item in response.mapItems {
                self.addPinToMapView(title: item.name,
                                     latitude: item.placemark.location!.coordinate.latitude,
                                     longitude: item.placemark.location!.coordinate.longitude)
                self.arrayOfResutls.append(item)
                
                print("\(self.arrayOfResutls)")
                }
            }
        })
    }
    
    // Add pins of results to map
    func addPinToMapView(title: String?,
                         latitude: CLLocationDegrees,
                         longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude,
                                                  longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            foodSearchMapView.addAnnotation(annotation)
        }
    }
    
    // Map setup
    func setupMap() {
        // mapViewLayoutConstraints()
        createCompass()
        foodSearchMapView.tintColor = .orange
        foodSearchMapView.showsBuildings = true
        foodSearchMapView.showsUserLocation = true
        foodSearchMapView.showsTraffic = true
        foodSearchMapView.mapType = .standard
        foodSearchMapView.delegate = self
        foodSearchMapView.showsScale = true
//        foodSearchMapView.showsCompass = true
        let coordinateRegion = MKCoordinateRegion.init(center: userCurrentLocation.coordinate,
                                                       latitudinalMeters: searchRadius * 5.0,
                                                       longitudinalMeters: searchRadius * 5.0)
        foodSearchMapView.setRegion(coordinateRegion,
                          animated: true)
    }
    
    func createCompass() {
        // Creating Compass
        let compassButton = MKCompassButton(mapView: foodSearchMapView)
        
        // Make compass visible
        compassButton.compassVisibility = .visible
        
        // Add compass to mapView
        foodSearchMapView.addSubview(compassButton)
        
        // Disable translatesAutoresizingMaskIntoConstraints
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup layout for compass
        compassButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -10).isActive = true
        compassButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor,
                                           constant: 10).isActive = true
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        // searchBarLayoutConstraints()
    }

    // Determine Current Location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    // Location manager to set userLocation, center, and region
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        // Set userLocation
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Set center
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                            longitude: userLocation.coordinate.longitude)
        
        // Set region attritbutes
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
        // Set region on mapview
        self.foodSearchMapView.setRegion(region,
                               animated: true)
        
        // Stops updating the current location
        manager.stopUpdatingLocation()
        
        // Set coordinates to userCurrentLocation
        userCurrentLocation = CLLocation(latitude: userLocation.coordinate.latitude,
                                         longitude: userLocation.coordinate.longitude)
    }
    
    // Location manager failed
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    // User clicks on the annotation
//    func mapView(_ mapView: MKMapView,
//                 didSelect view: MKAnnotationView) {
//
//        if let restaurantTitle = view.annotation?.title,
//            let restaurantAddress = view.annotation?.coordinate
//        {
//            
//            navigatoToLocation = CLLocation(latitude: restaurantAddress.latitude,
//                                            longitude: restaurantAddress.longitude)
//            if let restaurantTitle = restaurantTitle {
//                selectedRestaurantTitle = restaurantTitle
//                restaurantNameLabel.text = restaurantTitle
//                selectRestaurantButton.setTitle("Select this restaurant",
//                                                for: .normal)
//                navigateToRestaurantButton.setTitle("Navigate to \(restaurantTitle)",
//                    for: .normal)
//                
//            }
//            navigateToRestaurantButton.isHidden = false
//            selectRestaurantButton.isHidden = false
//            print("User tapped on annotation with title: \(restaurantTitle!) \(restaurantAddress)")
//        }
//    }
    
    // Create setup function for labels
    func setupLabel() {
        
        // restaurantNameLabel setup
        // labelLayoutConstraints()
        restaurantNameLabel.text = ""
        restaurantNameLabel.adjustsFontSizeToFitWidth = true
        restaurantNameLabel.minimumScaleFactor = 0.2
    }
    

    
    // Create setup for segmented controls
    func setupSegmentedControls() {
        mapTypeSegmentedControl.selectedSegmentTintColor = .orange
        categoriesSegmentedControl.selectedSegmentTintColor = .orange

    }
    
    // Create UIAlertController for messages
    func messageErrorNoResults() {
        let alertController = UIAlertController(title: "No Results",
                                                message: "Your search returned no results.",
                                                preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default) { (action:UIAlertAction!) in
            
                                        // Code in this block will trigger when OK button tapped.
                                        print("No Results")
        }
        alertController.addAction(OKAction)
        self.present(alertController,
                     animated: true,
                     completion:nil)

    }
    
    // Function to alert user how many results were returned from search
    func messageResultsReturnedFromSearch(count: Int) {
        
            let alertController = UIAlertController(title: "\(count) Results Found",
                                                    message: "Your search returned \(count) results",
                                                    preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK",
                                         style: .default) { (action:UIAlertAction!) in
                                            // Code in this block will trigger when OK button tapped.
                                            print("No Results")
            }
            alertController.addAction(OKAction)
            self.present(alertController,
                         animated: true,
                         completion:nil)
    }
    
    // Segmented control function for map type
    @IBAction func mapTypeSegmentedControlChanged(_ sender: UISegmentedControl) {
        
        if mapTypeSegmentedControl.selectedSegmentIndex == 0  {
            foodSearchMapView.mapType = .standard
            
        } else {
            foodSearchMapView.mapType = .satellite
        }
    }
    
    // Navigate button tapped
    @IBAction func navigateToRestaurantButtonTapped(_ sender: UIButton) {
        let latitude = navigatoToLocation.coordinate.latitude
        let longitude = navigatoToLocation.coordinate.longitude
        
        let query = "?ll=\(latitude),\(longitude)&q="
        
        // Appending query to apple maps URL
         let urlString = "http://maps.apple.com/".appending(query)
        
        // Opening URL using apple maps
         if let url = URL(string: urlString) {
             UIApplication.shared.open(url,
                                       options: [:],
                                       completionHandler: nil)
        }
    }
    
    // Function to re-center map when myLocationbButton is tapped
    @IBAction func myLocationButtonTapped(_ sender: UIButton) {
        
        foodSearchMapView.delegate = self
        let coordinateRegion = MKCoordinateRegion.init(center: userCurrentLocation.coordinate,
                                                       latitudinalMeters: searchRadius * latitudinalMeters,
                                                       longitudinalMeters: searchRadius * longitudinalMeters)
        foodSearchMapView.setRegion(coordinateRegion,
                          animated: true)
        
    }
    
    // Function to change categories selected in segmented control
    @IBAction func categoriesSegmentedControlChanged(_ sender: UISegmentedControl) {
        
        if searchBar.text == "" {
            if categoriesSegmentedControl.selectedSegmentIndex == 0 {
            categories = [.restaurant]
            } else if categoriesSegmentedControl.selectedSegmentIndex == 1  {
                categories = [.brewery, .winery]
            } else if categoriesSegmentedControl.selectedSegmentIndex == 2 {
                categories = [.cafe]
            } else if categoriesSegmentedControl.selectedSegmentIndex == 3 {
                categories = [.bakery]
            }
        } else {
            if categoriesSegmentedControl.selectedSegmentIndex == 0 {
                categories = [.restaurant]
                searchBarSearchButtonClicked(searchBar)
            } else if categoriesSegmentedControl.selectedSegmentIndex == 1 {
                categories = [.brewery, .winery]
                searchBarSearchButtonClicked(searchBar)
            } else if categoriesSegmentedControl.selectedSegmentIndex == 2 {
                categories = [.cafe]
                searchBarSearchButtonClicked(searchBar)
            } else if categoriesSegmentedControl.selectedSegmentIndex == 3 {
                categories = [.bakery]
                searchBarSearchButtonClicked(searchBar)
            }
        }
    }
}
