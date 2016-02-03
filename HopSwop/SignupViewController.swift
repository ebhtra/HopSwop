//
//  SignupViewController.swift
//  HopSwop
//
//  Created by Ethan Haley on 1/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    // Will be used only to end editing
    var tapRecognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackgroundBeer()
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
    // Remove the keyboard by tapping on the view (method called by tapRecognizer)
    func handleTap() {
        view.endEditing(true)
    }
    // Remove the keyboard by hitting RETURN key (method called by delegate: self)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
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
    // TODO:
    //  --raise keyboard for entering text in fields
}