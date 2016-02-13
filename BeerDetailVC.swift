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
    
    var beer: HalfBeer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detes.text = beer.notes
        if beer.notes.isEmpty {
            detes.text = "Unfortunately, \(beer.maker) has not yet provided any notes or description."
        }
    }
    
}
