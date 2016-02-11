//
//  MyBeersVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/3/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class MyBeersVC: BeerLoginController,  UITableViewDelegate, UITableViewDataSource, WatchlistDelegate {
    
    @IBOutlet weak var swopTable: UITableView!
    @IBOutlet weak var watchTable: UITableView!
    
    var listOfBeers = [String]()
    var listOfBrewers = [String]()
    
    var watchbeerlist = [HalfBeer]()
    var swopbeerlist = [Beer]()
    
    override func viewDidLoad() {
        
        /*
        var newBeer = [String: AnyObject]()
        newBeer["notInDB"] = false
        newBeer["descrip"] = "This is a beer I made at home.  To test this app."
        newBeer["dbID"] = 999999
        
        ParseClient.sharedInstance.deleteFromParseTask(ParseClient.Methods.BeerObj, objectId: beerToDeleteId) { result, error in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print(result)
            }
        
        }
        
       // ParseClient.sharedInstance.postToParseTask(ParseClient.Methods.BeerObj, parameters: newBeer) { success, error in
        //
         //   if success {print("yes! beer was added")} else {print(error)}
       // }
       */
    }
    override func viewWillAppear(animated: Bool) {
        let button = parentViewController?.navigationItem.rightBarButtonItem
            
        button!.title! = "Add Beer"
        button!.target = self
        button!.action = "showEditor"
    }
    override func viewWillDisappear(animated: Bool) {
        parentViewController?.navigationItem.rightBarButtonItem?.title! = "Refresh"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == swopTable {
            return swopbeerlist.count
        } else {
            return watchbeerlist.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let beerCell = tableView.dequeueReusableCellWithIdentifier("beerCell") as! BeerCell
        //let beer = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Beer
        //print("made it to here")
        if tableView == watchTable {
            let watchbeer = watchbeerlist[indexPath.row]
            beerCell.beerName.text = watchbeer.name
            beerCell.brewery.text = watchbeer.maker
        } else {
            let swopper = swopbeerlist[indexPath.row]
            // add beername and brewer to Beer to be able to use here
            // add detail callout with chevron on right of cells
            // add editable/deletable with swipe
            //  this type of cell may be same as for beerlistVC later
        }
        
        
        
        return beerCell

    }
    func showEditor() {
        let beerEditor = storyboard!.instantiateViewControllerWithIdentifier("BeerEditor") as! BeerEditorVC
        //beerEditor.delegate = self
        navigationController?.pushViewController(beerEditor, animated: true)
    }
    func addToSwoplist(newBeer: Beer) {
        swopbeerlist.append(newBeer)
        swopTable.reloadData()
    }
    func addToWatchlist(newBeer: HalfBeer) {
        watchbeerlist.append(newBeer)
        watchTable.reloadData()
    }
}
