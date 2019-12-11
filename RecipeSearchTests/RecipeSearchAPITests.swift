//
//  RecipeSearchAPITests.swift
//  RecipeSearchTests
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
@testable import RecipeSearch

class RecipeSearchAPITests: XCTestCase {


    func testSearchChristmasCookie() {
        // arrange
        // convert string to url friendly string
        let searchQuery = "christmas cookies".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        // expectation
        let exp = XCTestExpectation(description: "searches found")
        
        // using string interpolation to build endpoint url
        let recipeEndpointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKey.appId)&app_key=\(SecretKey.appkey)&from=0&to=50"
        
        let request = URLRequest(url: URL(string: recipeEndpointURL)!)
        
        //act
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("appError: \(appError)")
            case .success(let data):
                
                // tells the test that its ok to run
                exp.fulfill()
                // assert
                XCTAssertGreaterThan(data.count, 800000, "data should be greater then \(data.count)")
                
            }
        }
        // if doesn't get data back in 5 sec, it will fail
        wait(for: [exp], timeout: 5.0)
        
    }
    // 3.TODO: write an async test to validate you do get back 50 recipes for the
    // "christmas cookies" search
    //Asynchronous test
    func testFetchRecipes() {
        // arrange
        let expectedRecipeCount = 50
        let exp = XCTestExpectation(description: "recipes found")
        // was failed first because here there is a space between christmas and cookies. Had to go to RecipeSearchApiClient and add: let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "tacos". To get rid of the space
        let searchQuery = "christmas cookies"
        
        // act
        RecipeSearchAPIClient.fetchRecipe(for: searchQuery) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("appError is \(appError)")
            case .success(let recipes):
                exp.fulfill()
                XCTAssertEqual(recipes.count, expectedRecipeCount)
            }
        }
        wait(for: [exp], timeout: 5.0)
    }
}
