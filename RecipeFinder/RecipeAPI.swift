//
//  RecipeManager.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/7/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation

class RecipeAPI {
	static let sharedAPI = RecipeAPI()
	
	
	private (set) var recipes:[Recipe] = {
		return [Recipe]()
	}()
	
	private (set) var searchTerm:String = {
		return String.Empty
	}()
	
	func getRecipes(forFoodWithName name:String, completionHandler: (error:ErrorType?)-> Void) {
		//clear dataset if different than previous search
		if searchTerm != name {
			clearRecipes()
			searchTerm = name
		}
		
		do {
			try RecipeClient.sharedClient.executeRecipeSearch(withQuery: name, completionHandler: { (recipes, error) in
				guard let recipes = recipes else {
					completionHandler(error: nil)
					return
				}
				
				guard error == nil else {
					print(error)
					completionHandler(error: error)
					return
				}
				
				self.addRecipes(recipes)
				
				completionHandler(error: nil)
			})
		} catch let error {
			print(error)
			completionHandler(error: error)
		}
	}
	
	private func addRecipes(recipes:[Recipe]) {
		for recipe in recipes {
			self.recipes.append(recipe)
		}
	}
	
	private func clearRecipes() {
		self.recipes.removeAll()
	}
}