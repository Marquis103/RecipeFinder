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
	lazy var coreDataStack:CoreDataStack = {
		return CoreDataStack.defaultStack
	}()
	
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
	@IBOutlet weak var nutritionView: UIView!
	@IBOutlet weak var favoriteButton: UIButton!
	
	//MARK: View Controller Lifecycle
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		setupRecipeDetails()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		//let height = getContentViewHeight()
		let nutritionViewHeight = nutritionView.frame.maxY
		
		if contentViewHeight.constant - CGFloat(nutritionViewHeight) < 0 {
			contentViewHeight.constant = nutritionViewHeight + 100
			//contentViewHeight.constant = nutritionViewHeight + 100.0 //constraint padding
		} else {
			if scrollView.contentSize.height - nutritionViewHeight < 130 {
				scrollView.contentSize.height = nutritionViewHeight + 10
			} else {
				scrollView.contentSize.height = nutritionViewHeight
			}
		}
	}
	
	//MARK: Actions
	
	@IBAction func addFavorite(sender: UIButton) {
		if let recipe = recipe, let _ = recipe.nutrition {
			
			_ = RecipeEntity(context: coreDataStack.managedObjectContext, recipe: recipe, imageData: UIImageJPEGRepresentation(recipeDetailImage.image!, 0.80)!)
			
			do {
				try coreDataStack.saveContext()
			} catch {
				let alert = getUIAlertController(withActvityTitle: "Favorites Error", message: "There was an error adding \(recipe.title) to your favorites.  Please try again.", actionTitle: "OK")
				
				presentViewController(alert, animated: true, completion: nil)
			}
		}
	}
	
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
			//get recipe image if connected to the network
			//or get cached image from coredata if favorite
			if let imageData = recipe.imageData {
				recipeDetailImage.image = UIImage(data: imageData)
			} else {
				if let imageURLString = recipe.image {
					if Reachability.connectedToNetwork() {
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
				} else {
					recipeDetailImage.image = UIImage(named: "food_icn_no_image")
				}
			}
			
			//set recipe info details
			recipeTitle.text = recipe.title
			recipeDifficulty.text = (recipe.level == 0) ? "Difficulty Level: Not Available" : "Diffculty Level: \(recipe.level)"
			sourceButton.setTitle(recipe.source, forState: .Normal)
			
			//set recipe prep time to NA -- could not find values given API values
			prepTime.text = "NA"
			cookTime.text = "NA"
			totalTime.text = "NA"
			
			//set ingredients text and view
			let ingredientString = recipe.ingredients.reduce(String.Empty, combine: { (ingredientAccumulator, ingredient) -> String in
				ingredientAccumulator + ingredient + "\n"
			})
			
			ingredientsListView.layoutManager.delegate = self
			ingredientsListView.text = String(ingredientString.characters.dropLast())

			//set nutrition labels and view
			if let nutrition = recipe.nutrition {
				lblCalories.text = String(format: "%.2f g", nutrition.calories)
				lblFat.text = String(format: "%.2f g", nutrition.fat)
				lblCarbs.text = String(format: "%.2f g", nutrition.carbs)
				lblSodium.text = String(format: "%.2f mg", nutrition.sodium)
				lblProtein.text = String(format: "%.2f g", nutrition.protein)
			}
			
			nutritionView.layer.borderColor = UIColor.blackColor().CGColor
			nutritionView.layer.borderWidth = 1.0
		}
	}
}

extension RecipeDetailViewController:NSLayoutManagerDelegate {
	func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
		return 8
	}
}











