//
//  StashViewController.swift
//  OpenPantry
//
//  Created by Danny on 9/7/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class StashViewController: UIViewController {
    
    var stash = [DetailedRecipe]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noStashView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noStashView.backgroundColor = UIColor.paperGray()
        tableView.backgroundColor = UIColor.paperGray()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StashViewController.changeStashIntoRecipes), name: "UserLoggedIn", object: nil)
        
        setupRefreshControl()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        refreshData()
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        refreshData()
        
        refreshControl.endRefreshing()
    }

    func refreshData() {
        stash.removeAll()
        changeStashIntoRecipes()
        tableView.reloadData()
    }
    
    func changeStashIntoRecipes() {
        DataService.retrieveRecipeStash { (identifierStash) in
            if let identifiers = identifierStash {
                if identifiers.count == 0 {
                    self.showNoStashView(true)
                }
                var count = 0
                for identifier in identifiers {
                    OpenPantryAPI.getDetailedRecipeInformation(identifier, completion: { (recipe) in
                        self.stash.append(recipe)
                        count += 1
                        if count == identifiers.count {
                            self.tableView.reloadData()
                            self.showNoStashView(false)
                        }
                    })
                }
            }
        }
    }
    
    func showNoStashView(show: Bool) {
        if show {
            noStashView.hidden = false
        } else {
            noStashView.hidden = true
        }
    }
    
    class func create() -> StashViewController {
        let storyboard = UIStoryboard(name: "StashView", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("StashViewController") as! StashViewController
        return controller
    }
}

extension StashViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stash.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let recipe = stash[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("StashedCell") as? GeneralSearchedCell else {
            fatalError("Must have identifier of \(GeneralSearchedCell.identifier)")
        }
        
        cell.detailedRecipe = recipe
        
        cell.configureCellDetailed()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let recipe = stash[indexPath.row]
        tableView.allowsSelection = false
        
        let recipeViewController = RecipeViewController.create(recipe)
        self.navigationController?.pushViewController(recipeViewController, animated: true)
        tableView.allowsSelection = true
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
}
