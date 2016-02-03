//
//  MyBeersVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/3/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class MyBeersVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var newBeer = [String: AnyObject]()
        newBeer["notInDB"] = false
        newBeer["descrip"] = "This is a beer I made at home.  To test this app."
        newBeer["dbID"] = 999999
        
        ParseClient.sharedInstance.postToParseTask(newBeer) { success, error in
        
            if success {print("yes! beer was added")} else {print(error)}
        }
    }
}
