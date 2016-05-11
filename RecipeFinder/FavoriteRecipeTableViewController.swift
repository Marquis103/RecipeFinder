//
//  FavoriteRecipeTableViewController.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/10/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRecipeTableViewController: UITableViewController {

	//MARK: Properties
	var dataSource:FavoriteRecipeTableViewControllerDataSource!
	
	var loadingView = ActivityIndicatorLoadingView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
	
	private var isUpdating = false
	
	var selectedRecipe:Recipe?
	
	//MARK: View Controller LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource = FavoriteRecipeTableViewControllerDataSource(withTableView: tableView)
		tableView.delegate = self
		
		loadingView.center = view.center
		view.addSubview(loadingView)
		
		do {
			try dataSource.performFetch()
		} catch {
			let alert = getUIAlertController(withActvityTitle: "Internet Connection Required", message: "An Internet connection will be required to search for recipes.", actionTitle: "OK")
			presentViewController(alert, animated: true, completion: nil)
			return
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		/*guard Reachability.connectedToNetwork() == true else {
			let alert = UIAlertController(title: "Internet Connection Required", message: "An Internet connection will be required to search for recipes.", preferredStyle: .Alert)
			let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
			alert.addAction(action)
			presentViewController(alert, animated: true, completion: nil)
			return
		}*/
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "favRecipeDetailSegue" {
			let destinationController = segue.destinationViewController as! RecipeDetailViewController
			if let recipe = selectedRecipe {
				destinationController.recipe = recipe
			}
		}
	}
	
	//MARK: Methods
	func updateRecipes() {
		/*guard Reachability.connectedToNetwork() == true else {
			let alert = UIAlertController(title: "Internet Connection Required", message: "An Internet connection is required to search for recipes.", preferredStyle: .Alert)
			let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
			alert.addAction(action)
			presentViewController(alert, animated: true, completion: nil)
			return
		}*/
		
		//perform search
		/*recipeAPI.getRecipes(forFoodWithName: recipeSearchBar.text!, isUpdatingQuery: true) { (error) in
			self.isUpdating = false
			performUIUpdatesOnMain({
				self.tableView.reloadData()
			})
		}*/
	}
}

extension FavoriteRecipeTableViewController {
	override func scrollViewDidScroll(scrollView: UIScrollView) {
		let currentOffset = scrollView.contentOffset.y
		let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
		let deltaOffset = maximumOffset - currentOffset
		
		if deltaOffset <= 0 && !isUpdating {
			isUpdating = true
			
			updateRecipes()
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedRecipe = dataSource.fetchedResultsController.objectAtIndexPath(indexPath) as? Recipe
		
		performSegueWithIdentifier("favRecipeDetailSegue", sender: nil)
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			let recipe = dataSource.fetchedResultsController.objectAtIndexPath(indexPath)
			
			let coreData = CoreDataStack.defaultStack
			
			coreData.managedObjectContext.deleteObject(recipe as! NSManagedObject)
			
			do {
				try coreData.saveContext()
			} catch let error as NSError {
				print(error)
			}
		}
	}
}
