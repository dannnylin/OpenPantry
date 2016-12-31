//
//  SearchViewController.swift
//  OpenPantry
//
//  Created by Danny on 8/19/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

enum SearchMode {
    case RegularSearch
    case IngredientSearch
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBarContainerView: UIView!
    var addedIngredients = [String]()
    
    var dataSource = [GeneralSearchedRecipe]() {
        didSet {
            activityIndicator.stopAnimating()
            if dataSource.count > 0 {
                tableView.separatorStyle = .SingleLine
            }
            tableView.reloadData()
        }
    }
    
    var mode: SearchMode = .RegularSearch
    
    var ingredientSearchDataSource = [Recipe]() {
        didSet {
            activityIndicator.stopAnimating()
            if ingredientSearchDataSource.count > 0 {
                tableView.separatorStyle = .SingleLine
            }
            mode = .IngredientSearch
            tableView.reloadData()
        }
    }
    
    var customSearchController: CustomSearchController!
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCustomSearchController()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
        
        tableView.backgroundColor = UIColor.paperGray()
        tableView.separatorStyle = .None
        tableView.keyboardDismissMode = .Interactive
        
        tableView.registerNib(UINib(nibName: "IngredientSearchedCell", bundle: nil), forCellReuseIdentifier: "IngredientSearchedCell")
    }
    
    class func create() -> SearchViewController {
        let storyboard = UIStoryboard(name: "SearchView", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        
        let _ = controller.view
        
        return controller
    }
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRectMake(0.0, 0.0, tableView.frame.size.width, 50.0), searchBarFont: UIFont(name: "HelveticaNeue", size: 16.0)!, searchBarTextColor: UIColor.bloodRed(), searchBarTintColor: UIColor.indigoBlue())
        
        customSearchController.customSearchBar.placeholder = "Search for recipes"
        customSearchController.customSearchBar.showsBookmarkButton = true
        customSearchController.customSearchBar.setImage(UIImage(named: "add"), forSearchBarIcon: .Bookmark, state: .Normal)
        
        customSearchController.customDelegate = self
        
        searchBarContainerView.addSubview(customSearchController.customSearchBar)
        
        setupSearchBarWidth()
    }
    
    func setupSearchBarWidth() {
        customSearchController?.customSearchBar.frame.size.width = searchBarContainerView.frame.size.width
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        customSearchController.customSearchBar.sizeToFit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupSearchBarWidth()
    }
    
    internal func sanitizeAndSearch(searchBar: UISearchBar) {
        let dirtyQuery = customSearchController.customSearchBar.text
        let sanitized = dirtyQuery?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if let query = sanitized where !query.isEmpty {
            if customSearchController.customSearchBar.text != query {
                // Replace search bar text with sanitized search query
                customSearchController.customSearchBar.text = query
            }
            
            performSearch(query)
        }
    }
    
    private func resetUI() {
        switch mode {
        case .RegularSearch:
            dataSource.removeAll()
        case .IngredientSearch:
            ingredientSearchDataSource.removeAll()
        }
        tableView.separatorStyle = .None
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .RegularSearch:
            if shouldShowSearchResults {
                return dataSource.count
            }
            return 0
        case .IngredientSearch:
            return ingredientSearchDataSource.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch mode {
        case .RegularSearch:
            let recipe = dataSource[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCellWithIdentifier(GeneralSearchedCell.identifier) as? GeneralSearchedCell else {
                fatalError("Must have identifier of \(GeneralSearchedCell.identifier)")
            }
            
            cell.recipe = recipe
            cell.configureCell()
            
            return cell
        case .IngredientSearch:
            let recipe = ingredientSearchDataSource[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCellWithIdentifier("IngredientSearchedCell") as? IngredientSearchedCell else {
                fatalError("Must have identifier of IngredientSearchedCell")
            }
            
            cell.recipe = recipe
            cell.configureCell()
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var recipeIdentifier: UInt?
        
        switch mode {
        case .RegularSearch:
            recipeIdentifier = dataSource[indexPath.row].id
        case .IngredientSearch:
            recipeIdentifier = ingredientSearchDataSource[indexPath.row].id
        }
        
        
        guard let identifier = recipeIdentifier else {
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    func performSearch(query: String) {
        activityIndicator.startAnimating()
        let allowedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        OpenPantryAPI.searchForRecipes(allowedQuery) { (recipes) in
            self.dataSource = recipes
        }
    }
    
    func performIngredientSearch(query: String) {
        activityIndicator.startAnimating()
        let allowedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        OpenPantryAPI.searchForByIngredients(allowedQuery) { (recipes) in
            self.ingredientSearchDataSource = recipes
        }
    }
}

extension SearchViewController: CustomSearchControllerDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        performSearch(searchString)

        tableView.reloadData()
    }
    
    func didStartSearching() {
        customSearchController.customSearchBar.showsCancelButton = true
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        switch mode {
        default:
            if !shouldShowSearchResults {
                shouldShowSearchResults = true
                tableView.reloadData()
            }
            customSearchController.customSearchBar.showsCancelButton = false
        }
    }
    
    
    func didTapOnCancelButton() {
        switch mode {
        case .IngredientSearch:
            mode = .RegularSearch
        default:
            return
        }
        
        resetUI()
        shouldShowSearchResults = false
        customSearchController.customSearchBar.text = ""
        customSearchController.customSearchBar.resignFirstResponder()
        customSearchController.customSearchBar.showsCancelButton = false
        tableView.reloadData()
    }
    
    
    func didChangeSearchText(searchText: String) {
        if searchText.isEmpty {
            resetUI()
        }
        
        mode = .RegularSearch
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        performSelector(#selector(SearchViewController.sanitizeAndSearch(_:)), withObject: customSearchController.customSearchBar, afterDelay: 0.65)
    }
    
    func didTapOnBookmarkButton() {
        let addIngredientViewController = AddIngredientViewController.create()
        addIngredientViewController.parentSearchViewController = self
        let addIngredientNavigationController = UINavigationController(rootViewController: addIngredientViewController)
        presentViewController(addIngredientNavigationController, animated: true, completion: nil)
    }
}
