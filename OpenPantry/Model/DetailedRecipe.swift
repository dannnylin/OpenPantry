//
//  DetailedRecipe.swift
//  OpenPantry
//
//  Created by Danny on 8/15/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit
import SwiftyJSON

struct DetailedRecipe {
    var title: String?
    var id: UInt?
    var image: String?
    var vegetarian: Bool?
    var vegan: Bool?
    var glutenFree: Bool?
    var dairyFree: Bool?
    var veryHealthy: Bool?
    var cheap: Bool?
    var veryPopular: Bool?
    var sustainable: Bool?
    var weightWatcherSmartPoints: UInt?
    var gaps: String?
    var lowFodmap: Bool?
    var ketogenic: Bool?
    var whole30: Bool?
    var servings: UInt?
    var preparationMinutes: UInt?
    var cookingMinutes: UInt?
    var sourceUrl: String?
    var aggregateLikes: UInt?
    var extendedIngredients: [Ingredient]?
    
    init(json: JSON) {
        title = json["title"].string ?? ""
        id = json["id"].uInt ?? 0
        image = json["image"].string ?? ""
        vegetarian = json["vegetarian"].bool ?? false
        vegan = json["vegan"].bool ?? false
        glutenFree = json["glutenFree"].bool ?? false
        dairyFree = json["dairyFree"].bool ?? false
        veryHealthy = json["veryHealthy"].bool ?? false
        cheap = json["cheap"].bool ?? false
        veryPopular = json["veryPopular"].bool ?? false
        sustainable = json["sustainable"].bool ?? false
        weightWatcherSmartPoints = json["weightWatcherSmartPoints"].uInt ?? 0
        gaps = json["gaps"].string ?? ""
        lowFodmap = json["lowFodmap"].bool ?? false
        ketogenic = json["ketogenic"].bool ?? false
        whole30 = json["whole30"].bool ?? false
        servings = json["servings"].uInt ?? 0
        preparationMinutes = json["preparationMinutes"].uInt ?? 0
        sourceUrl = json["sourceUrl"].string ?? ""
        aggregateLikes = json["aggregateLikes"].uInt ?? 0
        
        if let ingredients = json["extendedIngredients"].array{
            extendedIngredients = ExtendedIngredients(jsonArray: ingredients).ingredients
        }
    }
}