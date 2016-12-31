//
//  UIView+Extras.swift
//  OpenPantry
//
//  Created by Danny on 7/8/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

extension UIView {
    func addDropShadow() {
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.5
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
}