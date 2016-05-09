//
//  Recipe.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/7/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation

typealias Calories = Float
typealias Ingredients = [String]

struct Recipe {
	//constants
	let title:String
	let ingredients: Ingredients
	let source: String
	
	//variables
	var prepTime: Double?
	var cookTime: Double?
	var level:Int?
	var image:NSData?
	var nutrition:Nutrition?
	var url: String?
	
	//computed properties
	var totalTime:Double? {
		if let prepTime = prepTime, let cookTime = cookTime {
			return prepTime + cookTime
		}
		
		return nil
	}
}

typealias Grams = Float
typealias Milligrams = Float

struct Nutrition {
	let calories:Calories
	let fat:Grams
	let carbs:Grams
	let protein:Grams
	let sodium:Milligrams
}

