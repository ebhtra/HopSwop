//
//  ResetPWViewController.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/4/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class ResetPWViewController: BeerLoginController {
    
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.becomeFirstResponder()
    }
    
    @IBAction func sendEmail(sender: UIButton) {
        if emailField.text == nil || emailField.text!.isEmpty {
            displayGenericAlert("Please enter your email.", message: "")
        } else {
           PFUser.requestPasswordResetForEmailInBackground(emailField.text!) { success, error in
                if success {
                    self.displayGenericAlert("An email was just sent to you.", message: "Please follow its instructions to reset your password.")
                } else {
                    self.displayErrorAlert(error!)
                }
            }
        }
    }

    @IBAction func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
