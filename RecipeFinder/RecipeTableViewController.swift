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
	var delegate:RecipeTableViewControllerDelegate!
	
	var loadingView = ActivityIndicatorLoadingView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
	var recipeAPI = RecipeAPI.sharedAPI
	
	//MARK: Outlets
	@IBOutlet weak var recipeSearchBar: UISearchBar!
	
	//MARK: View Controller LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource = RecipeTableViewControllerDataSource()
		delegate = RecipeTableViewControllerDelegate()

		tableView.dataSource = dataSource
		tableView.delegate = delegate
		
		
		loadingView.center = view.center
		view.addSubview(loadingView)
		
		recipeSearchBar.delegate = self
	}
}

extension RecipeTableViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		loadingView.show()
		
		//perform search
		recipeAPI.getRecipes(forFoodWithName: searchBar.text!) { (error) in
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