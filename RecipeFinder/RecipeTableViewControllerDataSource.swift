//
//  RecipeTableViewControllerDataSource.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/8/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class RecipeTableViewControllerDataSource:NSObject, UITableViewDataSource {
	private weak var tableView: UITableView!
	
	/*
	init(withTableView tableView:UITableView) {
		self.tableView = tableView
		super.init()
	}*/
	
	//MARK: UITableViewDataSource
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return RecipeAPI.sharedAPI.recipes.count
		
		/*if let navController = tableView.window?.rootViewController as? RecipeNavigationController {
			if let recipes = navController.recipes {
				return recipes.count
			} else {
				return 0
			}
		} else {
			return 0
		}*/
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell") as! RecipeTableViewCell
		let recipe = RecipeAPI.sharedAPI.recipes[indexPath.row]
		
		cell.configureCell(recipe)
		
		return cell
	}
}