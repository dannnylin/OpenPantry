//
//  FeaturedIngredientCell.swift
//  OpenPantry
//
//  Created by Danny on 8/15/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class FeaturedIngredientCell: UITableViewCell {
    static let identifier = "Featured-Ingredient-Cell"
    
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    var recipe: Recipe?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(recipe: Recipe) {
        self.recipe = recipe
        
        if let image = recipe.image, title = recipe.title {
            let imageUrl = "\(RECIPE_IMAGE_BASE_URL)\(image)"
            ingredientImageView.getImageFromUrl(imageUrl)
            ingredientImageView.clipsToBounds = true
            recipeTitleLabel.text = title
        }
        
    }
}
