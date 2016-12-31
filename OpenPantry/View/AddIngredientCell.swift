//
//  AddIngredientCell.swift
//  OpenPantry
//
//  Created by Danny on 8/20/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

protocol AddIngredientDelegate {
    func deleteIngredient(index: Int)
}

class AddIngredientCell: UITableViewCell {
    
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: AddIngredientDelegate?
    var index: Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.paperGray()
        separatorInset = UIEdgeInsetsZero
        ingredientLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightSemibold)
        ingredientLabel.textColor = UIColor.darkGrayColor()
        deleteButton.tintColor = UIColor.bloodRed()
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        print("Delete \(ingredientLabel.text)")
        delegate?.deleteIngredient(index)
    }
}
