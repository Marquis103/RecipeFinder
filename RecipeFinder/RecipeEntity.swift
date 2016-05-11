//
//  RecipeEntity.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/10/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation
import CoreData


class RecipeEntity: NSManagedObject {
	
	override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
		super.init(entity: entity, insertIntoManagedObjectContext: context)
	}
	
	init(context:NSManagedObjectContext) {
		let entity = NSEntityDescription.entityForName("RecipeEntity", inManagedObjectContext: context)!
		super.init(entity: entity, insertIntoManagedObjectContext: context)
	}
	
	init(context:NSManagedObjectContext, recipe:Recipe, imageData:NSData) {
		let entity = NSEntityDescription.entityForName("RecipeEntity", inManagedObjectContext: context)!
		super.init(entity: entity, insertIntoManagedObjectContext: context)
		
		image = imageData
		commonInit(recipe)
	}
	
	private func commonInit(recipe:Recipe) {
		calories = recipe.nutrition!.calories
		fat = recipe.nutrition!.fat
		carbs = recipe.nutrition!.carbs
		protein = recipe.nutrition!.protein
		sodium = recipe.nutrition!.sodium
		url = recipe.url
		source = recipe.source
		cookTime = recipe.cookTime ?? 0.0
		prepTime = recipe.prepTime ?? 0.0
		difficulty = 0
		ingredients = recipe.ingredients
		date = NSDate().timeIntervalSince1970
		title = recipe.title
	}
	
	func convertToRecipe() -> Recipe {
		let nutrition = Nutrition(calories: calories, fat: fat, carbs: carbs, protein: protein, sodium: sodium)
		let recipe = Recipe(title: title, ingredients: ingredients, source: source, prepTime: prepTime, cookTime: cookTime, level: 0, image: nil, nutrition: nutrition, url: url, imageData: image)
		
		return recipe
	}
}
