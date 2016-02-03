//
//  ViewControllerExtensions.swift
//  HopSwop
//
//  Created by Ethan Haley on 1/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayErrorAlert(error: NSError) {
        if let errorMessage = error.userInfo["error"] as? String {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showBackgroundBeer() {
        self.view.backgroundColor = UIColor.whiteColor()
        let colorTop = UIColor(red: 0.9, green: 0.6, blue: 0.1, alpha: 0.0).CGColor
        let colorMid = UIColor(red: 1.0, green: 0.7, blue: 0.1, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.85, green: 0.4, blue: 0.05, alpha: 1.0).CGColor
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorMid, colorBottom]
        backgroundGradient.locations = [0.2, 0.25, 1.0]
        backgroundGradient.frame = CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.height)
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
}
