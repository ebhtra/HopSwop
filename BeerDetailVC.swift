//
//  BeerDetailVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/13/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class BeerDetailVC: BeerLoginController {
    
    @IBOutlet weak var detes: UITextView!
    
    var beer: Beer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detes.text = beer.descrip
        if beer.descrip.isEmpty {
            detes.text = "Unfortunately, \(beer.brewer) has not yet provided any notes or description."
        }
    }
    
}
