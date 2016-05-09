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
	
	let client = RecipeClient.sharedClient
	
	private (set) var recipes:[Recipe] = {
		return [Recipe]()
	}()
	
	private (set) var searchTerm:String = {
		return String.Empty
	}()
	
	func getRecipes(forFoodWithName name:String, isUpdatingQuery:Bool, completionHandler: (error:ErrorType?)-> Void) {
		
		evaluateSearchTerm(name, isUpdatingQuery: isUpdatingQuery)
		
		do {
			try client.executeRecipeSearch(withQuery: searchTerm, completionHandler: { (recipes, error) in
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
	
	private func evaluateSearchTerm(query:String, isUpdatingQuery:Bool) {
		//clear dataset if different than previous search
		if searchTerm != query {
			//edge case -- User scrolls to the bottom expecting more results from previous query but the text has changed
			//current implementation will continue to scroll with the current dataset and not reset query value
			if !isUpdatingQuery {
				clearRecipes()
				searchTerm = query
				client.pageCount = 0
			} else {
				client.pageCount += 1
			}
			
		} else {
			if isUpdatingQuery {
				client.pageCount += 1
			} else {
				clearRecipes()
				client.pageCount = 0
			}
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