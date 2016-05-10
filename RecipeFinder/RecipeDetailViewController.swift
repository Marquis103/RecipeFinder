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
	@IBOutlet weak var contentViewHeight: NSLayoutConstraint!
	@IBOutlet weak var containerView: UIView!
	
	//MARK: View Controller Lifecycle
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		setupRecipeDetails()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let height = getContentViewHeight()
		
		if contentViewHeight.constant - CGFloat(height) < 100 {
			contentViewHeight.constant = CGFloat(height) + 145.0 //constraint padding
		} else {
			contentViewHeight.constant = contentViewHeight.constant - 20
		}
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
	private func getContentViewHeight() -> Double {
		let value = scrollView.subviews.reduce(0.0) { (total, subview) -> Double in
			total + Double(subview.frame.size.height)
		}
		
		return value
	}
	
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
			prepTime.text = "NA"
			cookTime.text = "NA"
			totalTime.text = "NA"
			sourceButton.setTitle(recipe.source, forState: .Normal)
			
			let ingredientString = recipe.ingredients.reduce(String.Empty, combine: { (ingredientAccumulator, ingredient) -> String in
				ingredientAccumulator + ingredient + "\n"
			})
			
			ingredientsListView.layoutManager.delegate = self
			
			ingredientsListView.text = String(ingredientString.characters.dropLast())
			
			let fixedWidth = ingredientsListView.frame.size.width
			ingredientsListView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
			let newSize = ingredientsListView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
			var newFrame = ingredientsListView.frame
			newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
			ingredientsListView.frame = newFrame;
			
			if let nutrition = recipe.nutrition {
				lblCalories.text = String(format: "%.2f g", nutrition.calories)
				lblFat.text = String(format: "%.2f g", nutrition.fat)
				lblCarbs.text = String(format: "%.2f g", nutrition.carbs)
				lblSodium.text = String(format: "%.2f mg", nutrition.sodium)
				lblProtein.text = String(format: "%.2f g", nutrition.protein)
			}
		}
	}
}

extension RecipeDetailViewController:NSLayoutManagerDelegate {
	func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
		return 8
	}
}











