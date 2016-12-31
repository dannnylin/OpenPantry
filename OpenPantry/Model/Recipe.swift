//
//  Recipe.swift
//  OpenPantry
//
//  Created by Danny on 7/8/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

struct Recipe {
    var id: UInt?
    var title: String?
    var image: String?
    var imageType: String?
    var usedIngredientCount: UInt?
    var missedIngredientCount: UInt?
    var likes: UInt?
    
    init(json: JSON) {
        missedIngredientCount = json["missedIngredientCount"].uInt ?? 0
        id = json["id"].uInt ?? 0
        title = json["title"].string ?? ""
        image = json["image"].string ?? ""
        imageType = json["imageType"].string ?? ""
        usedIngredientCount = json["usedIngredientCount"].uInt ?? 0
        likes = json["likes"].uInt ?? 0
    }
}

struct IngredientSearchRecipesResult {
    var recipes = [Recipe]()
    
    init(json: JSON) {
        let resultsJson = json["results"]
        for (_, subjson) in resultsJson {
            let recipe = Recipe(json: subjson)
            recipes.append(recipe)
        }
    }
}

struct IngredientsSearchRecipesResult {
    var recipes = [Recipe]()
    init(json: JSON) {
        for subjson in json.arrayValue {
            let recipe = Recipe(json: subjson)
            recipes.append(recipe)
        }
    }
}

struct GeneralSearchedRecipe {
    var id: UInt?
    var title: String?
    var readyInMinutes: UInt?
    var image: String?
    
    init(json: JSON) {
        id = json["id"].uInt ?? 0
        title = json["title"].string ?? ""
        readyInMinutes = json["readyInMinutes"].uInt ?? 0
        image = json["image"].string ?? ""
    }
}

struct GeneralSearchRecipeResults {
    var recipes = [GeneralSearchedRecipe]()
    
    init(json: JSON) {
        let resultsJson = json["results"]
        for (_, subjson) in resultsJson {
            let recipe = GeneralSearchedRecipe(json: subjson)
            recipes.append(recipe)
        }
    }
}