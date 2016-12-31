//
//  AppDelegate.swift
//  OpenPantry
//
//  Created by Danny on 7/7/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = UIColor.bloodRed()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(17)]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        application.statusBarStyle = .LightContent
    
        FIRApp.configure()
        
        if OpenPantryUserDefaults.getUID() != nil {
            window?.rootViewController = MainTabBarController.create()
            NSNotificationCenter.defaultCenter().postNotificationName("UserLoggedIn", object: nil)
        } else {
            window?.rootViewController = LoginViewController.create()
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    class func topViewController() -> UIViewController? {
        guard var topController = UIApplication.sharedApplication().keyWindow?.rootViewController else {
            return nil
        }
        
        while topController.presentedViewController != nil {
            let candidate = topController.presentedViewController!
            
            if let _ = candidate as? UIAlertController {
                break
            }
            
            topController = candidate
        }
        
        return topController
    }
}

