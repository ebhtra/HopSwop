//
//  MyMessagesVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/5/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class MyMessagesVC: BeerLoginController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let button = parentViewController?.navigationItem.rightBarButtonItem
        button!.target = self
        button?.action = "refreshMessages"
    }
    func refreshMessages() {
        print("hola")
    }

}