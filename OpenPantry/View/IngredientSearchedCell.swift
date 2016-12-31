//
//  IngredientSearchedCell.swift
//  OpenPantry
//
//  Created by Danny on 9/13/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class IngredientSearchedCell: UITableViewCell {
    
    let identifier = "IngredientSearchedCell"
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var ingredientsUsedLabel: UILabel!
    
    var recipe: Recipe!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        if let image = recipe.image, title = recipe.title, usedIngredients = recipe.usedIngredientCount, missedIngredients = recipe.missedIngredientCount {
            recipeImageView.getImageFromUrl(image)
            recipeTitleLabel.text = title
            ingredientsUsedLabel.text = "Used Ingredients: \(usedIngredients) • Missing Ingredients: \(missedIngredients)"
        }
    }
}
