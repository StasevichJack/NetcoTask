//
//  StorageController.swift
//  NetcoTask
//
//  Created by Jack on 3/18/18.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation

class StorageController {
    
    private init () {
    }
    
    class func getContext() -> NSManagedObjectContext {
        StorageController.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return StorageController.persistentContainer.viewContext
    }
    
    class func applicationDocumentsDirectory() -> URL? {
        if var url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            url = url.appendingPathComponent("Application Support/Storage.sqlite")
            return url
        }
        return nil
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Storage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = self.getContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Delete all CoreData.
    class func removeAllData() {
        do {
            if let url = self.applicationDocumentsDirectory() {
                let context = self.getContext()
                try context.persistentStoreCoordinator?.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
                try context.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            }
        } catch {
            print("Error:\(error)")
        }
    }
}
