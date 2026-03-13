//
//  CoreDataManager.swift
//  Transaction-Ledger
//
//  Created by ATEU on 3/12/26.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // Singleton instance so the whole app shares one database connection
    static let shared = CoreDataManager()
    
    private init() {}
    
    // 1. The Database Engine
    lazy var persistentContainer: NSPersistentContainer = {
        // 🚨 CRITICAL: This exact string must match your .xcdatamodeld file name
        let container = NSPersistentContainer(name: "LedgerDataModel")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("❌ Core Data failed to load: \(error)")
            }
        }
        return container
    }()
    
    // 2. The Scratchpad (Context)
    // You make changes here, then call saveContext() to write them to the device
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 3. The Save Command
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("💾 Successfully saved to Core Data!")
            } catch {
                print("❌ Error saving to Core Data: \(error)")
            }
        }
    }
}
