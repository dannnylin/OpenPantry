//
//  WebViewController.swift
//  OpenPantry
//
//  Created by Danny on 8/15/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            webView.loadRequest(NSURLRequest(URL: url))
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(donePressed(_:)))
        
    }
    
    func donePressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    class func create(url: NSURL) -> WebViewController {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        
        controller.url = url
        
        let _ = controller.view
        
        return controller
    }
    
    class func createWithinNavigationController(url: NSURL) -> UINavigationController {
        let viewController = WebViewController.create(url)
        return UINavigationController(rootViewController: viewController)
    }
}
