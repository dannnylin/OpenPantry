//
//  CuisineCell.swift
//  OpenPantry
//
//  Created by Danny on 7/18/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class CuisineCell: UITableViewCell {

    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var cuisineImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cuisineImageView.clipsToBounds = true
    }
}
