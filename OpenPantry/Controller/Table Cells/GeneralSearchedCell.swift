//
//  GeneralSearchedCell.swift
//  OpenPantry
//
//  Created by Danny on 8/19/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class GeneralSearchedCell: UITableViewCell {
    static let identifier = "General-Searched-Cell"
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeReadyInMinutesLabel: UILabel!
    
    var recipe: GeneralSearchedRecipe!
    var detailedRecipe: DetailedRecipe!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        if let image = recipe.image, minutes = recipe.readyInMinutes {
            let imageUrl = "\(RECIPE_IMAGE_BASE_URL)\(image)"
            if image != "" {
                recipeImageView.getImageFromUrl(imageUrl)
            }
            recipeImageView.clipsToBounds = true
            recipeReadyInMinutesLabel.text = "Ready in \(minutes) minutes"
            recipeTitleLabel.text = recipe.title?.capitalizedString
        }
    }
    
    func configureCellDetailed() {
        if let image = detailedRecipe.image {
            recipeImageView.getImageFromUrl(image)
            recipeImageView.clipsToBounds = true
            if let minutes = detailedRecipe.cookingMinutes {
                recipeReadyInMinutesLabel.text = "Ready in \(minutes) minutes"
            } else {
                recipeReadyInMinutesLabel.text = ""
            }
            recipeTitleLabel.text = detailedRecipe.title?.capitalizedString
        }
    }
}
