//
//  LoginViewController.swift
//  OpenPantry
//
//  Created by Danny on 9/5/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        setupButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    func setupButtons() {
        createAccountButton.layer.cornerRadius = 5.0
        signInButton.layer.cornerRadius = 5.0
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    @IBAction func createAccount(sender: UIButton) {
        let signInViewController = SignInViewController.create()
        signInViewController.mode = .Create
        let signInNavigationController = UINavigationController(rootViewController: signInViewController)
        self.presentViewController(signInNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func signIn(sender: UIButton) {
        let signInViewController = SignInViewController.create()
        signInViewController.mode = .SignIn
        let signInNavigationController = UINavigationController(rootViewController: signInViewController)
        self.presentViewController(signInNavigationController, animated: true, completion: nil)
    }
    
    class func create() -> LoginViewController {
        let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        return controller
    }
}