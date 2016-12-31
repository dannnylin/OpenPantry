//
//  Ingredient.swift
//  OpenPantry
//
//  Created by Danny on 7/8/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Ingredient {
    var id: UInt?
    var aisle: String?
    var image: String?
    var name: String?
    var unit: String?
    var unitShort: String?
    var unitLong: String?
    var originalString: String?
    var metaInformation: [String]?
    
    init(json: JSON) {
        id = json["id"].uInt ?? 0
        aisle = json["aisle"].string ?? ""
        image = json["image"].string ?? ""
        name = json["name"].string ?? ""
        unit = json["unit"].string ?? ""
        unitShort = json["unitShort"].string ?? ""
        unitLong = json["unitLong"].string ?? ""
        originalString = json["originalString"].string ?? ""
        metaInformation = json["metaInformation"].arrayObject as? [String] ?? []
    }
}

struct ExtendedIngredients {
    var ingredients = [Ingredient]()
    
    init(jsonArray: [JSON]) {
        for json in jsonArray {
            let ingredient = Ingredient(json: json)
            ingredients.append(ingredient)
        }
    }
}