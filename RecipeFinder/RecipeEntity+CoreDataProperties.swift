//
//  RecipeEntity+CoreDataProperties.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/10/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RecipeEntity {

	@NSManaged var title: String
	@NSManaged var ingredients: Ingredients
	@NSManaged var source: String
	@NSManaged var prepTime: Double
	@NSManaged var cookTime: Double
	@NSManaged var difficulty: Int64
	@NSManaged var url: String?
	@NSManaged var calories: Calories
	@NSManaged var fat: Grams
	@NSManaged var carbs: Grams
	@NSManaged var protein: Grams
	@NSManaged var sodium: Milligrams
	@NSManaged var image: NSData?
    @NSManaged var date: NSTimeInterval

}
