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


class LoginViewController: BeerLoginController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //See if user is logged in with Parse
        if let user = PFUser.currentUser() {
            print(user.valueForKey("emailVerified") as! Bool)
            if user.authenticated && user.valueForKey("emailVerified") as! Bool == true {
                completeLogin()
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
    
    @IBAction func loginTapped(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { user, error in
            
            if user != nil {
                if user!.valueForKey("emailVerified") as! Bool == false {
                    self.displayGenericAlert("Error", message: "Please check your email to verify the link to HopSwop")
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

