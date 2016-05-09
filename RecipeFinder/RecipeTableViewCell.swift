//
//  RecipeTableViewCell.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/9/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

	@IBOutlet weak var recipeImage: UIImageView!
	@IBOutlet weak var recipeCalories: UILabel!
	@IBOutlet weak var recipeDifficulty: UILabel!
	@IBOutlet weak var recipeName: UILabel!
	
	func configureCell(recipe: Recipe) {
		setLabelFonts()
		
		if let imageURLString = recipe.image {
			performImageNetworkOperations({
				if let url = NSURL(string: imageURLString), let data = NSData(contentsOfURL: url) {
					performUIUpdatesOnMain({
						if let image = UIImage(data: data) {
							self.recipeImage.image = image
						} else {
							self.recipeImage.image = UIImage(named: "food_icn_no_image")
						}
					})
				}
			})
		} else {
			recipeImage.image = UIImage(named: "food_icn_no_image")
		}
		recipeImage.layer.cornerRadius = CGRectGetWidth(recipeImage.frame) / 2.0
		
		recipeCalories.text = "\(recipe.nutrition?.calories)"
		recipeDifficulty.text = "\(recipe.level)"
		recipeName.text = recipe.title
		
	}
	
	private func setLabelFonts() {
		recipeName.font = UIFont.preferredFontForTextStyle("UIFontTextStyleTitle1")
		recipeDifficulty.font = UIFont.preferredFontForTextStyle("UIFontTextStyleSuheadline")
		recipeCalories.font = UIFont.preferredFontForTextStyle("UIFontTextStyleCaption1")
	}
}
