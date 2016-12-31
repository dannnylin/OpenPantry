//
//  SettingsViewController.swift
//  OpenPantry
//
//  Created by Danny on 8/15/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FBSDKLoginKit

enum SettingsOptions {
    case AdvancedOptions
    case HelpFAQ
    case Share
    case RateUs
    case Contact
    case Logout
}

class SettingsOptionCell: UITableViewCell {
    static let identifier = "Settings-Option-Cell"
    
    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class SettingsViewController: UIViewController {
    
    var dataSource: [[SettingsOptions]] = [[.AdvancedOptions, .HelpFAQ, .Share, .RateUs ,.Contact], [.Logout]]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    class func create() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "SettingsView", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
        
        let _ = controller.view
        
        return controller
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let settingType = dataSource[indexPath.section][indexPath.row]
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(SettingsOptionCell.identifier) as? SettingsOptionCell else {
            fatalError("SettingsViewController needs identifier of \(SettingsOptionCell.identifier)")
        }
        
        
        switch settingType {
        case .AdvancedOptions:
            cell.optionLabel.text = "Advanced Options"
        case .HelpFAQ:
            cell.optionLabel.text = "Help/FAQ"
        case .Share:
            cell.optionLabel.text = "Share"
        case .RateUs:
            cell.optionLabel.text = "Rate the App"
        case .Contact:
            cell.optionLabel.text = "Contact"
        case .Logout:
            cell.optionLabel.text = "Log out"
        }
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let settingType = dataSource[indexPath.section][indexPath.row]
        
        switch settingType {
        case .Share:
            let menu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let emailAction = UIAlertAction(title: "Email", style: .Default, handler: { (action) in
                let mailController = MFMailComposeViewController()
                mailController.mailComposeDelegate = self
                mailController.setSubject("Start cooking on OpenPantry!")
                mailController.setMessageBody("Join me on OpenPantry, an app that I recently started using to improve my cooking skills. I have been getting compliments from everyone around me and I think you should give it a try as well! Download it here!", isHTML: false)
                if MFMailComposeViewController.canSendMail() {
                    self.presentViewController(mailController, animated: true, completion: nil)
                }
            })
            
            let messageAction = UIAlertAction(title: "Message", style: .Default, handler: { (action) in
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate = self
                messageController.body = "Download OpenPantry to brushen up your cooking skills with the ability to search for recipes by ingredients!"
                self.presentViewController(messageController, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            menu.addAction(emailAction)
            menu.addAction(messageAction)
            menu.addAction(cancelAction)
            self.presentViewController(menu, animated: true, completion: nil)
        case .Contact:
            let email = "hello@openpantry.xyz"
            let url = NSURL(string: "mailto:\(email)")!
            UIApplication.sharedApplication().openURL(url)
        case .Logout:
            try! FIRAuth.auth()!.signOut()
            FBSDKAccessToken.setCurrentAccessToken(nil)
            OpenPantryUserDefaults.clearUID()
            
            self.presentViewController(LoginViewController.create(), animated: true, completion: nil)
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResultSent:
            print("Email successfully sent")
        case MFMailComposeResultSaved:
            print("Email saved")
        case MFMailComposeResultFailed:
            print("Email failed")
        case MFMailComposeResultCancelled:
            print("Email cancelled")
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SettingsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result {
        case MessageComposeResultSent:
            print("Message sent")
        case MessageComposeResultFailed:
            print("Message failed")
        case MessageComposeResultCancelled:
            print("Message cancelled")
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
