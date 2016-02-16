//
//  SwopBeerVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/16/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class SwopBeerVC: UIViewController {
    
    @IBOutlet weak var beerLabel: UILabel!
    @IBOutlet weak var brewerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackgroundBeer()
    }
    
}
