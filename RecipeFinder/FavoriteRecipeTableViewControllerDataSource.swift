//
//  FavoriteRecipeTableViewControllerDataSource.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/11/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRecipeTableViewControllerDataSource:NSObject, UITableViewDataSource {
	private weak var tableView:UITableView!
	
	init(withTableView tableView:UITableView) {
		super.init()
		self.tableView = tableView
		self.tableView.dataSource = self
	}
	
	func performFetch() throws {
		do {
			try fetchedResultsController.performFetch()
		} catch let error as NSError {
			tableView = nil
			NSLog("Error during fetch\n \(error)")
			throw error
		}
	}
	
	//MARK: UITableViewDataSource
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let sections = fetchedResultsController.sections {
			return sections.count
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController.sections {
			let sectionInfo = sections[section]
			return sectionInfo.numberOfObjects
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath) as! RecipeTableViewCell
		
		let recipe = fetchedResultsController.objectAtIndexPath(indexPath) as! RecipeEntity
		
		cell.configureCell(recipe.convertToRecipe())
		
		return cell
	}
	
	//MARK: FetchRequest
	func entryListFetchRequest() -> NSFetchRequest {
		let fetchRequest = NSFetchRequest(entityName: "RecipeEntity")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
		
		return fetchRequest
	}
	
	//MARK: NSFetchedResultsController
	lazy var fetchedResultsController:NSFetchedResultsController = {
		let coreData = CoreDataStack.defaultStack
		
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.entryListFetchRequest(), managedObjectContext: coreData.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		
		fetchedResultsController.delegate = self
		
		return fetchedResultsController
	}()
}

//MARK: UITableViewDelegate
/*extension FavoriteRecipeTableViewControllerDataSource: UITableViewDelegate {
	//MARK: TableViewControllerDelegate
	
}*/

//MARK: NSFetchedResultsControllerDelegate
extension FavoriteRecipeTableViewControllerDataSource: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		tableView.beginUpdates()
	}
	
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		switch(type) {
		case .Delete:
			tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
			break
		case .Insert:
			tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
			break
		case .Update:
			tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
			break
		default:
			break
		}
		
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}
	
	func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
		switch type {
		case .Insert:
			tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
			break
			
		case .Delete:
			tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
			break
			
		default:
			break
			
		}
	}
}
