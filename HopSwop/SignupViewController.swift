//
//  SignupViewController.swift
//  HopSwop
//
//  Created by Ethan Haley on 1/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class SignupViewController: BeerLoginController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func signUpPressed(sender: AnyObject) {
        let user = PFUser()
        user.username = usernameField.text
        user.email = emailField.text
        user.password = passwordField.text
        
        user.signUpInBackgroundWithBlock { success, error in
            if (success) {
                self.showEmailAlert()
            } else if let error = error {
                self.displayErrorAlert(error)
            }
        }
    }
    func showEmailAlert() {
        let alert = UIAlertController(title: "An email was sent to the address you just provided.", message: "Please verify the link in your email.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {_ in self.dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
    