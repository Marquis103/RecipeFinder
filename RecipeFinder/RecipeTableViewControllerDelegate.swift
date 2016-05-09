//
//  RecipeTableViewControllerDelegate.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/8/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class RecipeTableViewControllerDelegate: NSObject, UITableViewDelegate {
	let recipeAPI = RecipeAPI.sharedAPI
	var tableViewController = RecipeTableViewController()
	private var isUpdating = false
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let currentOffset = scrollView.contentOffset.y
		let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
		let deltaOffset = maximumOffset - currentOffset
		
		if deltaOffset <= 0 && !isUpdating {
			isUpdating = true
			
			recipeAPI.getRecipes(forFoodWithName: String.Empty, isUpdatingQuery: true) { (error) in
				self.isUpdating = false
				performUIUpdatesOnMain({
					self.tableViewController.tableView.reloadData()
				})
			}
		}
	}
}