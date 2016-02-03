//
//  LoginViewController.swift
//  HopSwop
//
//  Created by Ethan Haley on 1/27/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    // Will be used only to end editing
    var tapRecognizer: UITapGestureRecognizer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        showBackgroundBeer()
        
        //See if user is logged in with Parse
        if let user = PFUser.currentUser() {
            print(user.valueForKey("emailVerified") as! Bool)
            if user.authenticated && user.valueForKey("emailVerified") as! Bool == true {
                completeLogin()
            }
        }
    
        // Set up the tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addGestureRecognizer(tapRecognizer!)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.removeGestureRecognizer(tapRecognizer!)
    }
    // Since this VC isn't in the same UINavigation stack as the rest of the app
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        // log out of Parse
        PFUser.logOutInBackground()
        
        // if logged in through FB, log out using FB's LoginManager method
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKLoginManager().logOut()
        }
    }
    // Remove the keyboard by tapping on the view (method called by tapRecognizer)
    func handleTap() {
        view.endEditing(true)
    }
    // Remove the keyboard by hitting RETURN key (method called by delegate: self)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    @IBAction func loginTapped(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { user, error in
            
            if user != nil {
                if user!.valueForKey("emailVerified") as! Bool == false {
                    let alert = UIAlertController(title: "Error", message: "Please check your email to verify the link to HopSwop", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.completeLogin()
                }
            } else if let error = error {
                self.displayErrorAlert(error)
            }
        }
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("fb logged in")
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("fb logged out")
    }
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue()) {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RootNavController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    

}

