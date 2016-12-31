//
//  UITableView+Extras.swift
//  OpenPantry
//
//  Created by Danny on 8/20/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToLastCell() {
        self.scrollToRowAtIndexPath(lastIndexPath(), atScrollPosition: .Bottom, animated: true)
    }
    
    func lastIndexPath() -> NSIndexPath {
        let lastSectionIndex = self.numberOfSections - 1
        let lastRowIndex = self.numberOfRowsInSection(lastSectionIndex)-1
        return NSIndexPath(forRow: lastRowIndex, inSection: lastSectionIndex)
    }
}