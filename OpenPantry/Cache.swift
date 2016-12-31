//
//  Cache.swift
//  OpenPantry
//
//  Created by Danny on 8/19/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class OpenPantryCache {
    static let cache: NSCache = {
        let cache = NSCache()
        cache.name = "OpenPantryCache"
        cache.countLimit = 40
        cache.totalCostLimit = 20 * 1024 * 1024
        return cache
    }()
}