//
//  CoreDataStack.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/19/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
	static let defaultStack = CoreDataStack()
	static let moduleName = "RecipeFinder"

	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		if let modelURL = NSBundle.mainBundle().URLForResource(moduleName, withExtension: "momd") {
			
			//if the managed model doesn't exist the persistent store coordinator can't be created
			if let managedModel = NSManagedObjectModel(contentsOfURL: modelURL) {
				// The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
				let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
				
				// The directory the application uses to store the Core Data data store file. This code uses a directory named "com.flashbolt.RecipeFinder" in the application's documents Application Support directory.
				let applicationDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
				
				//location on disk of the actual persistent store
				let persistentStoreURL = applicationDocumentsDirectory.URLByAppendingPathComponent("\(moduleName).sqlite")
				
				var failureReason = "There was an error creating or loading the application's saved data."
				
				do {
					//add persistent store to coordinator
					try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistentStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
				} catch {
					// Report any error we got.
					var dict = [String: AnyObject]()
					dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
					dict[NSLocalizedFailureReasonErrorKey] = failureReason
					
					dict[NSUnderlyingErrorKey] = error as NSError
					let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
					// Replace this with code to handle the error appropriately.
					// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
					abort()
				}
				
				return coordinator
			}
			
			return nil
		}
		
		return nil
	}()
	
	lazy var managedObjectContext: NSManagedObjectContext = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()
	
	
	func saveContext () throws {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch {
				let nserror = error as NSError
				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
				throw error
				//abort()
			}
		}
	}
}