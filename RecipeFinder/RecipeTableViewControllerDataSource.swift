//
//  RecipeTableViewControllerDataSource.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/8/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class RecipeTableViewControllerDataSource:NSObject, UITableViewDataSource {	
	//MARK: UITableViewDataSource
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return RecipeAPI.sharedAPI.recipes.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell") as! RecipeTableViewCell
		let recipe = RecipeAPI.sharedAPI.recipes[indexPath.row]
		
		cell.configureCell(recipe)
		
		return cell
	}
}