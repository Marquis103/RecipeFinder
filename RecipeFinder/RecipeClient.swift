//
//  RecipeClient.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/7/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation

struct RecipeClient {
	static let sharedClient = RecipeClient()
	
	//MARK: Struct Properties
	private let session = NSURLSession.sharedSession()
	private struct Constants {
		struct RecipeAPI {
			static let Scheme = "https"
			static let Host = "api.edamam.com"
			static let Path = "/search"
			static let Key = "e0c0610a32a9c73a1a7d1fb3bb8ef2ce"
			static let Id = "9ef83afb"
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
		}
		
		if let url = components.URL {
			return NSURLRequest(URL: url)
		} else {
			return nil
		}
		
	}
	
	private func checkForRequestErrors(data:NSData?, response:NSURLResponse?, error:NSError?) -> RecipeClientError? {
		func sendError(error:String) -> NSError {
			print(error)
			let userInfo = [NSLocalizedDescriptionKey : error]
			return NSError(domain: "taskForGetMethod", code: -1, userInfo: userInfo)
		}
		
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
	
	private func responseParser(data: [String: AnyObject]) -> [Recipe] {
		return [Recipe]()
	}
	
	func executeRecipeSearch(withQuery query:String) throws -> [Recipe] {
		var parameters = [String:AnyObject]()
		
		//static query parameters
		parameters["app_id"] = Constants.RecipeAPI.Id
		parameters["app_key"] = Constants.RecipeAPI.Key
		parameters["q"] = query
		
		guard let request = generateNSURLRequest(parameters) else {
			throw RecipeClientError.CouldNotGenerateRequest("Could not generate the request for the search string")
		}
		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			if let error = self.checkForRequestErrors(data, response: response, error: error) {
				print(error)
				return
			} else {
				var parsedResult:AnyObject!
				
				do {
					parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
					print(parsedResult)
				} catch let error {
					print (error)
				}
			}
		}
		
		task.resume()
		
		
		return [Recipe]()
	}
	
}