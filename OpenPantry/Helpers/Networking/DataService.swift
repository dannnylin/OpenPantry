//
//  DataService.swift
//  OpenPantry
//
//  Created by Danny on 9/6/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import Foundation
import Firebase

let FIREBASE_BASE_URL = "https://openpantry-90b0b.firebaseio.com/"

class DataService {
    static let instance = DataService()
    
    private var _USERS_REF = FIRDatabase.database().referenceFromURL("\(FIREBASE_BASE_URL)/users")
    
    var USERS_REF: FIRDatabaseReference {
        return _USERS_REF
    }
    
    func createFirebaseUser(uid: String, provider: String) {
        let userProvider = ["Provider": provider]
        USERS_REF.child(uid).setValue(userProvider)
    }
    
    func addRecipeToStash(recipeID: UInt) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            USERS_REF.child(uid).child("stashed").updateChildValues(["\(recipeID)": true])
        }
    }
    
    func removeRecipeFromStash(recipeID: UInt) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            USERS_REF.child(uid).child("stashed").updateChildValues(["\(recipeID)": false])
        }
    }
    
    class func retrieveRecipeStash(completion: [UInt]? -> Void) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            DataService.instance.USERS_REF.child(uid).child("stashed").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                var stashedRecipes = [UInt]()
                if let stashDict = snapshot.value as? [String: Bool] {
                    for recipe in stashDict {
                        if let recipeId = UInt(recipe.0) {
                            let stashed = recipe.1
                            if stashed {
                                stashedRecipes.append(recipeId)
                            }
                        }
                    }
                    completion(stashedRecipes)
                } else {
                    completion(nil)
                }
            })
        }
    }

}