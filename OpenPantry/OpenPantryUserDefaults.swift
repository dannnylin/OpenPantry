//
//  OpenPantryUserDefaults.swift
//  OpenPantry
//
//  Created by Danny on 8/20/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class OpenPantryUserDefaults {
    static let UID_Key = "com.openpantry.uid"
    class func setUID(UID: String) {
        NSUserDefaults.standardUserDefaults().setObject(UID, forKey: UID_Key)
    }
    class func getUID() -> String? {
        let UID = NSUserDefaults.standardUserDefaults().objectForKey(UID_Key)
        if let UID = UID as? String {
            return UID
        }
        return nil
    }
    class func clearUID() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UID_Key)
    }
    
    static let addIngredientsKey = "com.openpantry.add-ingredients-key"
    class func getLastAddedIngredients() -> [String] {
        let ingredients = NSUserDefaults.standardUserDefaults().objectForKey(addIngredientsKey)
        if let ingredientArray = ingredients as? [String] {
            return ingredientArray
        } else {
            return []
        }
    }
    class func setLastAddedIngredients(ingredients: [String]) {
        NSUserDefaults.standardUserDefaults().setObject(ingredients, forKey: addIngredientsKey)
    }
    class func clearLastAddedIngredients() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(addIngredientsKey)
    }
}
