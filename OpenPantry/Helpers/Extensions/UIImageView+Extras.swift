//
//  UIImageView+Extras.swift
//  OpenPantry
//
//  Created by Danny on 8/15/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    func getImageFromUrl(url: String) {
        let encodedUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        if let image = OpenPantryCache.cache.objectForKey(encodedUrl) as? UIImage {
            self.image = image
        } else {
            Alamofire.request(.GET, encodedUrl).response { (request, response, data, error) in
                guard let data = data else {
                    fatalError("No data found")
                }
                if let retrievedImage = UIImage(data: data, scale: 1) {
                    OpenPantryCache.cache.setObject(retrievedImage, forKey: encodedUrl)
                    self.image = retrievedImage
                }
            }
        }
    }
}