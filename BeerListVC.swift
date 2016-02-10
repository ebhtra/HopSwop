//
//  BeerListVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/3/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class BeerListVC: BeerLoginController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let button = parentViewController?.navigationItem.rightBarButtonItem
        button!.target = self
        button?.action = "refreshList"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func refreshList() {
        
    }

}

