//
//  RecipeManager.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/7/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation

struct RecipeAPI {
	static let sharedAPI = RecipeAPI()
	
	private let recipeClient = RecipeClient.sharedClient
	
	private (set) var recipes:[Recipe] = {
		return [Recipe]()
	}()
	
	mutating func getRecipes(forFoodWithName name:String, completionHandler: (error:ErrorType?)-> Void) {
		do {
			try recipeClient.executeRecipeSearch(withQuery: name, completionHandler: { (recipes, error) in
				guard let recipes = recipes else {
					completionHandler(error: nil)
					return
				}
				
				guard error == nil else {
					print(error)
					completionHandler(error: error)
					return
				}
				
				self.recipes = recipes
				completionHandler(error: nil)
			})
		} catch let error {
			print(error)
			completionHandler(error: error)
		}
	}
}