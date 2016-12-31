//
//  SignInViewController.swift
//  OpenPantry
//
//  Created by Danny on 9/5/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

enum AccessMode {
    case Create
    case SignIn
}

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var mode: AccessMode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyling()
        
        emailTextField.tag = 0
        emailTextField.delegate = self
        passwordTextField.tag = 1
        passwordTextField.delegate = self
        
        let tapper = UITapGestureRecognizer(target: view, action:#selector(UIView.endEditing))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func forgotPassword() {
        if let email = emailTextField.text where email != "" {
            FIRAuth.auth()?.sendPasswordResetWithEmail(email, completion: { (error) in
                if let error = error {
                    print(error)
                    if error.code == 17011 {
                        self.showErrorAlert("Error", message: "An account with this e-mail was not found. Please try again!")
                    } else if error.code == 17008 {
                    self.showErrorAlert("Bad e-mail", message: "Please check the format of your e-mail and try again!")
                    }
                    return
                }
                
                self.showErrorAlert("Success", message: "A password reset link has been sent to your e-mail!")
            })
        } else {
            self.showErrorAlert("Enter e-mail", message: "Please type in your e-mail and press this button again!")
        }
    }
    
    @IBAction func facebookLoginPressed(sender: UIButton) {
        loginButtonClicked()
    }
    
    @IBAction func signInPressed(sender: AnyObject) {
        if let mode = mode {
            
            if emailTextField.text == "" || passwordTextField.text == "" {
                showErrorAlert("Error", message: "E-mail and password cannot be empty!")
            }
            
            if let email = emailTextField.text, password = passwordTextField.text {
                switch mode {
                case .SignIn:
                    FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
                        if let error = error {
                            print("Error code: \(error)")
                            if error.code == 17011 {
                                self.showErrorAlert("Error", message: "An account with this e-mail was not found. Please try again!")
                            } else if error.code == 17008 {
                                self.showErrorAlert("Bad e-mail", message: "Please check the format of your e-mail and try again!")
                            } else if error.code == 17009 {
                                self.showErrorAlert("Bad password", message: "Please check your password and try again!")
                            }
                            return
                        }
                        
                        if let uid = FIRAuth.auth()?.currentUser?.uid {
                            OpenPantryUserDefaults.setUID(uid)
                        }
                        
                        self.moveToMainScreen()
                        
                    })
                case .Create:
                    FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let uid = FIRAuth.auth()?.currentUser?.uid {
                            OpenPantryUserDefaults.setUID(uid)
                            DataService.instance.createFirebaseUser(uid, provider: "Email")
                        }
                        
                        self.moveToMainScreen()
                    })
                }
            }
        }
    }
    
    func loginButtonClicked() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else if result.isCancelled {
                print("Facebook login cancelled")
            } else {
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    
                    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                        // Login successful
                        if let error = error {
                            print(error)
                        }
                        
                        if let uid = user?.uid, mode = self.mode {
                            OpenPantryUserDefaults.setUID(uid)
                            
                            switch mode {
                            case .Create:
                                DataService.instance.createFirebaseUser(uid, provider: "Facebook")
                            case .SignIn:
                                print("Don't create new user")
                            }
                        }
                        
                        self.moveToMainScreen()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print(result["email"])
                }
            })
        }
    }
    
    class func create() -> SignInViewController {
        let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
        
        return controller
    }
    
    func setupStyling() {
        if let mode = mode {
            switch mode {
            case .SignIn:
                navigationItem.title = "SIGN IN"
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Forgot?", style: .Plain, target: self, action: #selector(forgotPassword))
            case .Create:
                navigationItem.title = "CREATE ACCOUNT"
                signInButton.setTitle("Create Account", forState: .Normal)
            }
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(dismiss))
            self.view.backgroundColor = UIColor.paperGray()
            
            signInButton.layer.cornerRadius = 5.0
            facebookLoginButton.layer.cornerRadius = 5.0
            facebookLoginButton.backgroundColor = UIColor.facebook()
            signInButton.backgroundColor = UIColor.bloodRed()
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        // Try to find next responder
        if let nextResponder: UIResponder! = textField.superview!.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            signInPressed(self)
        }
        return false // We do not want UITextField to insert line-breaks.
    }
}
