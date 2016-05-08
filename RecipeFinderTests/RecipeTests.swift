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
		let recipes = try! client.executeRecipeSearch(withQuery: "lasagne")
		print(recipes)
    }
}
