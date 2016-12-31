//
//  RecipeViewController.swift
//  OpenPantry
//
//  Created by Danny on 8/15/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit
import Firebase

class RecipeViewController: UIViewController {
    
    var detailedRecipe: DetailedRecipe!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var stashButton: UIButton!
    
    var userStashedRecipes = [UInt]()
    
    private var stashed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = detailedRecipe.image {
            recipeImageView.getImageFromUrl(image)
        }
        
        getStashedRecipes()
        
        setupStyling()
        
        var stepsString = ""
        if let recipeIdentifier = detailedRecipe.id {
            OpenPantryAPI.getInstructionsForRecipe(recipeIdentifier, completion: { (steps) in
                for step in steps {
                    stepsString += "•  \(step)\n"
                }
                self.instructionsLabel.text = stepsString
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
            })
        }
    }
    
    func setupStyling() {
        recipeImageView.clipsToBounds = true
        recipeTitleLabel.text = detailedRecipe.title
        recipeImageView.layer.cornerRadius = 3.0
        
        contentView.backgroundColor = UIColor.paperGray()
    }
    
    func getStashedRecipes() {
        DataService.retrieveRecipeStash { (recipes) in
            if let recipeId = self.detailedRecipe.id, recipes = recipes {
                if recipes.contains(recipeId) {
                    self.stashButton.setImage(UIImage(named: "stashed"), forState: .Normal)
                    self.stashed = true
                }
            }
        }
    }
    
    @IBAction func openSourceUrl(sender: UIButton) {
        if let sourceUrl = detailedRecipe.sourceUrl {
            let url = NSURL(string: sourceUrl)!
            let webViewController = WebViewController.createWithinNavigationController(url)
            self.presentViewController(webViewController, animated: true, completion: nil)
        }
    }
    
    class func create(recipe: DetailedRecipe) -> RecipeViewController {
        let storyboard = UIStoryboard(name: "RecipeView", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("RecipeViewController") as! RecipeViewController
        
        controller.detailedRecipe = recipe
        
        return controller
    }
    
    @IBAction func stashPressed(sender: UIButton) {
        if let recipeID = detailedRecipe.id {
            if stashed {
                DataService.instance.removeRecipeFromStash(recipeID)
                stashButton.setImage(UIImage(named: "unstashed"), forState: .Normal)
                stashed = false
            } else {
                DataService.instance.addRecipeToStash(recipeID)
                print("Stashed: Recipe with ID \(recipeID)")
                stashButton.setImage(UIImage(named: "stashed"), forState: .Normal)
                stashed = true
            }
        }
    }
}