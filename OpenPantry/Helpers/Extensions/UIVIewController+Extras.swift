//
//  UIVIewController+Extras.swift
//  OpenPantry
//
//  Created by Danny on 9/5/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func moveToMainScreen() {
        self.presentViewController(MainTabBarController.create(), animated: true, completion: nil)
    }
}