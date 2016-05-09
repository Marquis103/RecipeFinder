//
//  RecipeTests.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/7/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import XCTest
@testable import RecipeFinder

class RecipeTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testRecipeRequest() {
		let client = RecipeClient.sharedClient
		
		try! client.executeRecipeSearch(withQuery: "lasagne", completionHandler: { (recipes, error) in
			guard let recipes = recipes else {
				if let error = error {
					print (error)
				} else {
					print("there was no data")
				}
				return
			}
			
			print(recipes)
		})
    }
}
