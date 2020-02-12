//
//  RestaurantTableViewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/10/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController {
    
    let restaurantController = RestaurantController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Restaurant> = {
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as? RestaurantsTableViewCell else { return UITableViewCell()}
        
        let restaurant = fetchedResultsController.object(at: indexPath)
        cell.restaurant = restaurant
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
//        return sectionInfo.name.capitalized
//    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let restaurant = fetchedResultsController.object(at: indexPath)
            restaurantController.delete(restaurant: restaurant)
            
            CoreDataStack.shared.mainContext.delete(restaurant)
            restaurantController.saveToPersistenceStore()
        }
    }
}

extension RestaurantTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else{return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else{return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else{return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else{return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let sectionSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sectionSet, with: .automatic)
            
        case .delete:
            tableView.deleteSections(sectionSet, with: .automatic)
            
        default: return
        }
    }
}
