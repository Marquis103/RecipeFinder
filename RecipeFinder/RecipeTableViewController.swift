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
	
	//MARK: Methods
	func updateRecipes() {
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
		loadingView.show()
		
		//perform search
		recipeAPI.getRecipes(forFoodWithName: searchBar.text!, isUpdatingQuery: false) { (error) in
			performUIUpdatesOnMain({
				self.tableView.reloadData()
				self.loadingView.hide()
			})
		}
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		loadingView.hide()
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
}