//
//  CoreDataStack.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/6/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {
        
    }
    
    //Create Code Snippet
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading Persistent Stores: \(error)")
            }
        })
        return container
    }()
    
    // Creating only one instance for use
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveToPersistentStore() {
        do{
            try mainContext.save()
        } catch {
            NSLog("Error saving context \(error)")
            mainContext.reset()
        }
    }
}

