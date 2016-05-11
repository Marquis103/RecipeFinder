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

	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "favRecipeDetailSegue" {
			let destinationController = segue.destinationViewController as! RecipeDetailViewController
			if let recipe = selectedRecipe {
				destinationController.recipe = recipe
			}
		}
	}
}

extension FavoriteRecipeTableViewController {
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let managedRecipe = dataSource.fetchedResultsController.objectAtIndexPath(indexPath) as? RecipeEntity
		
		if managedRecipe != nil {
			selectedRecipe = managedRecipe?.convertToRecipe()
			performSegueWithIdentifier("favRecipeDetailSegue", sender: nil)
		}
		
	}
}
