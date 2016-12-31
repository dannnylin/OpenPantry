//
//  MainTabBarController.swift
//  OpenPantry
//
//  Created by Danny on 8/15/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var homeViewController: HomeViewController!
    var searchViewController: UIViewController!
    var stashViewController: UIViewController!
    var settingsViewController: UIViewController!
    
    var navigationControllers = [UINavigationController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViewControllers()
        
        setupNavigationControllers()
        
        self.viewControllers = navigationControllers
        self.tabBar.tintColor = UIColor.bloodRed()
    }
    
    func createViewControllers() {
        homeViewController = HomeViewController.create()
        homeViewController.view.backgroundColor = UIColor.paperGray()
        homeViewController.navigationItem.title = "DISCOVER"
        
        searchViewController = SearchViewController.create()
        searchViewController.view.backgroundColor = UIColor.paperGray()
        searchViewController.navigationItem.title = "SEARCH"
        
        stashViewController = StashViewController.create()
        stashViewController.view.backgroundColor = UIColor.paperGray()
        stashViewController.navigationItem.title = "STASH"
        
        settingsViewController = SettingsViewController.create()
        settingsViewController.view.backgroundColor = UIColor.paperGray()
        settingsViewController.navigationItem.title = "SETTINGS"
    }
    
    func setupNavigationControllers() {
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let stashNavigationController = UINavigationController(rootViewController: stashViewController)
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        
        homeNavigationController.tabBarItem.title = "DISCOVER"
        homeNavigationController.tabBarItem.image = UIImage(named: "home")
        
        searchNavigationController.tabBarItem.title = "SEARCH"
        searchNavigationController.tabBarItem.image = UIImage(named: "discover")
        
        stashNavigationController.tabBarItem.title = "STASH"
        stashNavigationController.tabBarItem.image = UIImage(named: "stash")
        
        settingsNavigationController.tabBarItem.title = "SETTINGS"
        settingsNavigationController.tabBarItem.image = UIImage(named: "settings")
        
        navigationControllers.append(homeNavigationController)
        navigationControllers.append(searchNavigationController)
        navigationControllers.append(stashNavigationController)
        navigationControllers.append(settingsNavigationController)
    }
    
    class func create() -> MainTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
        
        let _ = controller.view
        
        return controller
    }
}
