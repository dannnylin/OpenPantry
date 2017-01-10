//
//  OpenPantryAPI.swift
//  OpenPantry
//
//  Created by Danny on 7/8/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import SwiftyJSON
import Alamofire

class OpenPantryAPI: NSObject {
    static let instance = OpenPantryAPI()
    static let headers = ["X-Mashape-Key" : API_KEY]
    
    class func getByIngredients(cuisine: String, mainIngredient: String, completion: ([Recipe]) -> Void) {
        let url = NSURL(string: "\(BASE_URL)recipes/search?&cuisine=\(cuisine)&query=\(mainIngredient)&number=15")!
        Alamofire.request(.GET, url, parameters: nil, encoding: .URL, headers: headers).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error getting ingredients")
                return
            }
            
            let jsonData = JSON(response.result.value!)
            let searchResults = IngredientSearchRecipesResult(json: jsonData)
            
            completion(searchResults.recipes)
        }
    }
    
    class func getDetailedRecipeInformation(recipeIdentifier: UInt, completion: (DetailedRecipe) -> Void) {
        let url = NSURL(string: "\(BASE_URL)recipes/\(recipeIdentifier)/information")!
        Alamofire.request(.GET, url, parameters: nil, encoding: .URL, headers: headers).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error getting recipe information")
                return
            }
            
            let jsonData = JSON(response.result.value!)
            let recipe = DetailedRecipe(json: jsonData)
            
            completion(recipe)
        }
    }
    
    class func searchForRecipes(query: String, completion: ([GeneralSearchedRecipe]) -> Void) {
        let url = NSURL(string: "\(BASE_URL)recipes/search?&query=\(query)&number=25")!
        Alamofire.request(.GET, url, parameters: nil, encoding: .URL, headers: headers).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error getting recipes")
                return
            }
            
            let jsonData = JSON(response.result.value!)
            let searchResults = GeneralSearchRecipeResults(json: jsonData)
            
            completion(searchResults.recipes)
        }
    }
    
    class func getInstructionsForRecipe(recipeIdentifier: UInt, completion: ([String]) -> Void) {
        let url = NSURL(string: "\(BASE_URL)recipes/\(recipeIdentifier)/analyzedInstructions")!
        Alamofire.request(.GET, url, parameters: nil, encoding: .URL, headers: headers).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error getting instructions")
                return
            }
            
            let jsonData = JSON(response.result.value!)
            var stepsArray = [String]()
            let stepCount = jsonData[0]["steps"].count
            var counter = 0
            while counter < stepCount {
                let step = jsonData[0]["steps"][counter]["step"].stringValue
                stepsArray.append(step)
                counter += 1
            }
            
            completion(stepsArray)
        }
    }
    
    class func searchForByIngredients(query: String, completion: ([Recipe]) -> Void) {
        let cleanedQuery = query.stringByReplacingOccurrencesOfString(",", withString: "%2C")
        let url = NSURL(string: "\(BASE_URL)recipes/findByIngredients?ingredients=\(cleanedQuery)&number=25&ranking=1&fillIngredients=false")!
        Alamofire.request(.GET, url, parameters: nil, encoding: .URL, headers: headers).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error getting recipes")
                return
            }
            
            let jsonData = JSON(response.result.value!)
            
            let searchResults = IngredientsSearchRecipesResult(json: jsonData)
            
            completion(searchResults.recipes)
        }
    }
}
