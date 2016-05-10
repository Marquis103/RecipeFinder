//
//  RecipeNavigationController.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/8/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class RecipeNavigationController: UINavigationController {
	let navBar = UINavigationBar.appearance()
	
	override func viewDidLoad() {
		navBar.barTintColor = UIColor(red: 154.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
		navBar.tintColor = UIColor.whiteColor()
		navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
	}
}
