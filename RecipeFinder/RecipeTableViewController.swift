//
//  RecipeTableViewController.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/8/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController {
	
	//MARK: Properties
	var dataSource:RecipeTableViewControllerDataSource!
	
	var loadingView = ActivityIndicatorLoadingView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
	
	var recipeAPI = RecipeAPI.sharedAPI
	private var isUpdating = false
	
	var selectedRecipe:Recipe?
	
	//MARK: Outlets
	@IBOutlet weak var recipeSearchBar: UISearchBar!
	
	//MARK: View Controller LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource = RecipeTableViewControllerDataSource()

		tableView.dataSource = dataSource
		tableView.delegate = self
		
		loadingView.center = view.center
		view.addSubview(loadingView)
		
		recipeSearchBar.delegate = self
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		guard Reachability.connectedToNetwork() == true else {
			let alert = UIAlertController(title: "Internet Connection Required", message: "An Internet connection will be required to search for recipes.", preferredStyle: .Alert)
			let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
			alert.addAction(action)
			presentViewController(alert, animated: true, completion: nil)
			return
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "recipeDetailSegue" {
			let destinationController = segue.destinationViewController as! RecipeDetailViewController
			if let recipe = selectedRecipe {
				destinationController.recipe = recipe
			}
		}
	}
	
	//MARK: Methods
	func updateRecipes() {
		guard Reachability.connectedToNetwork() == true else {
			let alert = UIAlertController(title: "Internet Connection Required", message: "An Internet connection is required to search for recipes.", preferredStyle: .Alert)
			let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
			alert.addAction(action)
			presentViewController(alert, animated: true, completion: nil)
			return
		}
		
		//perform search
		recipeAPI.getRecipes(forFoodWithName: recipeSearchBar.text!, isUpdatingQuery: true) { (error) in
			self.isUpdating = false
			performUIUpdatesOnMain({
				self.tableView.reloadData()
			})
		}
	}
}

extension RecipeTableViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		
		guard Reachability.connectedToNetwork() == true else {
			let alert = UIAlertController(title: "Internet Connection Required", message: "An Internet connection is required to search for recipes.", preferredStyle: .Alert)
			let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
			alert.addAction(action)
			presentViewController(alert, animated: true, completion: nil)
			return
		}
		
		loadingView.show()
		
		//perform search
		recipeAPI.getRecipes(forFoodWithName: searchBar.text!, isUpdatingQuery: false) { (error) in
			guard error == nil else {
				performUIUpdatesOnMain({
					self.loadingView.hide()
					let alert = UIAlertController(title: "Query Error", message: "Sorry!  There was an error performing your query.  Please try again.", preferredStyle: .Alert)
					let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
					alert.addAction(action)
					self.presentViewController(alert, animated: true, completion: nil)
				})
				
				return
			}
			
			performUIUpdatesOnMain({
				if self.recipeAPI.recipes.count > 0 {
					self.loadingView.hide()
					self.tableView.reloadData()
				} else {
					self.loadingView.hide()
					let alert = UIAlertController(title: "Results Not Found", message: "Ooops!  It appears we could not find any results for \(searchBar.text!)", preferredStyle: .Alert)
					let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
					alert.addAction(action)
					self.presentViewController(alert, animated: true, completion: nil)
				}
			})
		}
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		loadingView.hide()
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}

extension RecipeTableViewController {
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
		selectedRecipe = recipeAPI.recipes[indexPath.row]
		
		performSegueWithIdentifier("recipeDetailSegue", sender: nil)
	}
}