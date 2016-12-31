//
//  CuisineViewController.swift
//  OpenPantry
//
//  Created by Danny on 7/20/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class CuisineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cuisine: String!
    var dataSource = [Recipe]() {
        didSet {
            tableView.reloadData()
        }
    }
    var randomNumber: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyling()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
        
        setupRefreshControl()
        
        loadData()
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        loadData()
        
        refreshControl.endRefreshing()
    }
    
    func loadData() {
        self.activityIndicator.startAnimating()
        
        randomNumber = generateRandomIndex(RANDOM_INGREDIENTS.count)
        OpenPantryAPI.getByIngredients(cuisine, mainIngredient: RANDOM_INGREDIENTS[randomNumber]) { (recipes) in
            self.dataSource = recipes
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    func setupStyling() {
        view.backgroundColor = UIColor.paperGray()
    }
    
    class func create(cuisine: String) -> CuisineViewController {
        let storyboard = UIStoryboard(name: "CuisineView", bundle: NSBundle(forClass: CuisineViewController.classForCoder()))
        guard let controller = storyboard.instantiateViewControllerWithIdentifier("CuisineViewController") as? CuisineViewController else {
            fatalError()
        }
        
        controller.navigationItem.title = cuisine
        controller.cuisine = cuisine
        
        let _ = controller.view
        
        return controller
    }
}

extension CuisineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let recipe = dataSource[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(FeaturedIngredientCell.identifier) as? FeaturedIngredientCell else {
            fatalError("No identifier found with \(FeaturedIngredientCell.identifier)")
        }
        
        cell.setupCell(recipe)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let recipe = dataSource[indexPath.row]
        
        guard let identifier = recipe.id else {
            fatalError("Recipe does not have identifier")
        }
        
        tableView.allowsSelection = false
        
        OpenPantryAPI.getDetailedRecipeInformation(identifier) { (detailedRecipe) in
            let recipeViewController = RecipeViewController.create(detailedRecipe)
            self.navigationController?.pushViewController(recipeViewController, animated: true)
            tableView.allowsSelection = true
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
