//
//  RecipeDetailViewController.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/9/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
	//MARK: Properties
	var recipe:Recipe?
	
	//Outlets
	@IBOutlet weak var recipeDetailImage: UIImageView!
	@IBOutlet weak var recipeTitle: UILabel!
	@IBOutlet weak var sourceButton: UIButton!
	@IBOutlet weak var recipeDifficulty: UILabel!
	@IBOutlet weak var ingredientsListView: UITextView!
	@IBOutlet weak var prepTime: UILabel!
	@IBOutlet weak var cookTime: UILabel!
	@IBOutlet weak var totalTime: UILabel!
	@IBOutlet weak var lblCalories: UILabel!
	@IBOutlet weak var lblFat: UILabel!
	@IBOutlet weak var lblCarbs: UILabel!
	@IBOutlet weak var lblProtein: UILabel!
	@IBOutlet weak var lblSodium: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!
	
	//MARK: View Controller Lifecycle
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		setupRecipeDetails()
	
		
	}
	
	//MARK: Actions
	@IBAction func visitRecipeSource(sender: UIButton) {
		if let urlString = recipe?.url {
			let url = NSURL(string: urlString)!
			
			if !UIApplication.sharedApplication().canOpenURL(url) && (!url.absoluteString.hasPrefix("http://") || !url.absoluteString.hasPrefix("https://")) {
				let urlString = "http://" + url.absoluteString
				UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
			} else {
				UIApplication.sharedApplication().openURL(url)
			}
		}
	}
	
	
	//MARK: Methods
	private func setupRecipeDetails() {
		recipeDetailImage.layer.cornerRadius = 10.0
		if let recipe = recipe {
			if let imageURLString = recipe.image {
				performImageNetworkOperations({
					if let url = NSURL(string: imageURLString), let data = NSData(contentsOfURL: url) {
						performUIUpdatesOnMain({
							if let image = UIImage(data: data) {
								self.recipeDetailImage.image = image
							} else {
								self.recipeDetailImage.image = UIImage(named: "food_icn_no_image")
							}
						})
					}
				})
			} else {
				recipeDetailImage.image = UIImage(named: "food_icn_no_image")
			}
			
			recipeTitle.text = recipe.title
			recipeDifficulty.text = (recipe.level == 0) ? "Difficulty Level: Not Available" : "Diffculty Level: \(recipe.level)"
			prepTime.text = "10m"
			cookTime.text = "15m"
			totalTime.text = "25m"
			sourceButton.setTitle(recipe.source, forState: .Normal)
			
			let ingredientString = recipe.ingredients.reduce(String.Empty, combine: { (ingredientAccumulator, ingredient) -> String in
				ingredientAccumulator + ingredient + "\n"
			})
			ingredientsListView.layoutManager.delegate = self
			ingredientsListView.text = String(ingredientString.characters.dropLast())
			
			if let nutrition = recipe.nutrition {
				lblCalories.text = String(format: "%.2f g", nutrition.calories)
				lblFat.text = String(format: "%.2f g", nutrition.fat)
				lblCarbs.text = String(format: "%.2f g", nutrition.carbs)
				lblSodium.text = String(format: "%.2f mg", nutrition.sodium)
				lblProtein.text = String(format: "%.2f g", nutrition.protein)
			}
			
			let contentHeight = getScrollViewContentSize()
			scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
		}
	}
	
	private func getScrollViewContentSize() -> CGFloat {
		let value = scrollView.subviews.reduce(0.0, combine: { (height, subview) -> CGFloat in
			height + subview.bounds.size.height
		})
		
		return value
	}
}

extension RecipeDetailViewController:NSLayoutManagerDelegate {
	func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
		return 8
	}
}
