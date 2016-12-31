//
//  ViewController.swift
//  OpenPantry
//
//  Created by Danny on 7/7/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyling()
        
        OpenPantryAPI.geocodeHTTPRequest("9701 Shore Front Parkway, Rockaway Beach, NY, 11693") { (response, error) in
            if let error = error {
                print(error)
            } else {
                print(response)
            }
        }
    }
    
    class func create() -> HomeViewController {
        let storyboard = UIStoryboard(name: "HomeView", bundle: NSBundle(forClass: HomeViewController.classForCoder()))
        guard let controller = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController else {
            fatalError()
        }
        
        let _ = controller.view
        
        return controller
    }
    
    func setupStyling() {
        tableView.backgroundColor = UIColor.paperGray()
        self.tableView.registerNib(UINib(nibName: "CuisineCell", bundle: nil), forCellReuseIdentifier: "cuisine-cell")
        tableView.showsVerticalScrollIndicator = false
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cuisine = CUISINES[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("cuisine-cell") as? CuisineCell else {
            fatalError()
        }
        
        cell.cuisineLabel.text = cuisine.uppercaseString
        cell.cuisineImageView.image = UIImage(named: cuisine)
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CUISINES.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let cell = self.tableView.dequeueReusableCellWithIdentifier("cuisine-cell") else {
            return 0
        }
        return cell.frame.height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cuisine = CUISINES[indexPath.row]
        
        let viewController = CuisineViewController.create(cuisine.uppercaseString)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
