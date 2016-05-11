//
//  RecipeClient.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/7/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation

class RecipeClient {
	static let sharedClient = RecipeClient()
	
	var keys:NSDictionary
	var appKey:String
	var appId:String
	
	//MARK: Initialization
	private init() {
		keys = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")!)!
		appKey = keys.objectForKey("ApplicationKey") as! String
		appId = keys.objectForKey("ApplicationId") as! String
	}
	
	//MARK: Struct Properties
	private let session = NSURLSession.sharedSession()
	private let itemsPerRequest = 10
	private var itemsFrom = 0
	private var itemsTo = 10
	
	var pageCount: Int = 0 {
		didSet {
			itemsFrom = itemsPerRequest * pageCount
			itemsTo = itemsFrom + itemsPerRequest
		}
	}
	
	private struct Constants {
		struct RecipeAPI {
			static let Scheme = "https"
			static let Host = "api.edamam.com"
			static let Path = "/search"
		}
		
		struct JSONKeys {
			static let recipeList = "hits"
			static let recipe = "recipe"
			static let source = "source"
			static let image = "image"
			static let title = "label"
			static let level = "level"
			static let url = "url"
			static let ingredientsList = "ingredientLines"
			static let calories = "calories"
			static let totalNutrients = "totalNutrients"
			static let fat = "FAT"
			static let carbs = "CHOCDF"
			static let sodium = "NA"
			static let protein = "PROCNT"
			static let value = "quantity"
			
		}
	}
	
	//MARK: Error Enum
	private enum RecipeClientError:ErrorType {
		case NetworkError
		case InvalidData(String)
		case QueryFailed(String)
		case CouldNotGenerateRequest(String)
	}
	
	//MARK: Request Functions
	private func generateNSURLRequest(parameters:[String:AnyObject]?) -> NSURLRequest? {
		let components = NSURLComponents()
		components.scheme = Constants.RecipeAPI.Scheme
		components.host = Constants.RecipeAPI.Host
		components.path = Constants.RecipeAPI.Path
		
		if let parameters = parameters {
			var queryItems = [NSURLQueryItem]()
			
			for (key, value) in parameters {
				if let value = value as? String {
					let queryItem = NSURLQueryItem(name: key, value: value)
					queryItems.append(queryItem)
				}
			}
			
			components.queryItems = queryItems
		}
		
		if let url = components.URL {
			return NSURLRequest(URL: url)
		} else {
			return nil
		}	
	}
	
	private func checkForRequestErrors(data:NSData?, response:NSURLResponse?, error:NSError?) -> RecipeClientError? {
		//was there an error?
		guard error == nil else {
			return RecipeClientError.InvalidData("Invalid data return from query. \(error)")
		}
		
		//did we get a successful response from the API?
		guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
			return RecipeClientError.QueryFailed("The query was unsuccessful")
		}
		
		//was there any data returned?
		guard let _ = data else {
			return RecipeClientError.InvalidData("Data from query was not available.")
		}
		
		return nil
	}
	
	
	private func parseRecipe(recipeDict: [String: AnyObject]) -> Recipe? {
		let source = recipeDict[Constants.JSONKeys.source] as! String
		let title = recipeDict[Constants.JSONKeys.title] as! String
		let ingredients = recipeDict[Constants.JSONKeys.ingredientsList] as! [String]
		let url = recipeDict[Constants.JSONKeys.url] as! String
		let image = recipeDict[Constants.JSONKeys.image] as! String
		return Recipe(title: title, ingredients: ingredients, source: source, prepTime: nil, cookTime: nil, level: 0, image: image, nutrition: nil, url: url, imageData: nil)
		
	}
	
	private func parseNutrition(nutritionDict: [String:AnyObject]) -> Nutrition? {
		if let totalNutrients = nutritionDict[Constants.JSONKeys.totalNutrients] as? [String:AnyObject] {
			let calories = nutritionDict[Constants.JSONKeys.calories] as? Float
			let fat = totalNutrients[Constants.JSONKeys.fat]?[Constants.JSONKeys.value] as? Float
			let carbs = totalNutrients[Constants.JSONKeys.carbs]?[Constants.JSONKeys.value] as? Float
			let sodium = totalNutrients[Constants.JSONKeys.sodium]?[Constants.JSONKeys.value] as? Float
			let protein = totalNutrients[Constants.JSONKeys.protein]?[Constants.JSONKeys.value] as? Float
			
			return Nutrition(calories: calories!, fat: fat!, carbs: carbs!, protein: protein!, sodium: sodium!)
		}
		
		return nil
	}
	
	private func responseParser(data: [String: AnyObject]) -> [Recipe] {
		var recipeItems = [Recipe]()
		
		if let recipeList = data[Constants.JSONKeys.recipeList] as? [[String:AnyObject]] {
			for recipe in recipeList {
				if let recipeDict = recipe[Constants.JSONKeys.recipe] as? [String:AnyObject] {
					let nutrition = parseNutrition(recipeDict)
					var recipe = parseRecipe(recipeDict)
					
					recipe?.nutrition = nutrition
					recipeItems.append(recipe!)
				}
			}
			
			return recipeItems
		}
		
		return recipeItems
	}
	
	func executeRecipeSearch(withQuery query:String, completionHandler: ([Recipe]?, ErrorType?) -> () ) throws -> Void {//[Recipe] {
		var parameters = [String:AnyObject]()
		
		//static query parameters
		parameters["app_id"] = appId
		parameters["app_key"] = appKey
		parameters["q"] = query
		parameters["from"] = String(itemsFrom)
		parameters["to"] = String(itemsTo)
		
		guard let request = generateNSURLRequest(parameters) else {
			throw RecipeClientError.CouldNotGenerateRequest("Could not generate the request for the search string")
		}
		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			if let error = self.checkForRequestErrors(data, response: response, error: error) {
				return completionHandler(nil, error)
			} else {
				var jsonResult:AnyObject!
				
				do {
					jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
					let recipes = self.responseParser(jsonResult as! [String : AnyObject])
					completionHandler(recipes, nil)
					
				} catch let error {
					print (error)
					completionHandler(nil, error)
				}
			}
		}
		
		task.resume()
	}
	
}