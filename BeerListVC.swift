//
//  BeerListVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/3/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import CoreData

class BeerListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var beerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackgroundBeer()
        
        // refreshList()  //- User can use refresh button for now
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let button = parentViewController?.navigationItem.rightBarButtonItem
        button!.target = self
        button?.action = "refreshList"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeerList.menu.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let ReuseIdentifier = "beerCell"
            
            let beer = BeerList.menu[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier)
            
            cell!.detailTextLabel?.text = beer.brewer
            cell!.textLabel?.text = beer.beerName
            
     // TODO: - Add location ability to sort by proximity
            
            return cell!
    }
    
    func refreshList() {
        // store a batch of beers from the Parse API and load them into map
        ParseClient.sharedInstance.refreshBeers() { success in
            if success {
                dispatch_async(dispatch_get_main_queue()) { _ in
                    self.beerTable.reloadData()
                }
            }
        }
    }
}

