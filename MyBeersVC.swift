//
//  MyBeersVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/3/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class MyBeersVC: BeerLoginController,  UITableViewDelegate, UITableViewDataSource {
    
    var listOfBeers = [String]()
    var listOfBrewers = [String]()
    
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
        return listOfBeers.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let beerCell = tableView.dequeueReusableCellWithIdentifier("beerCell") as! BeerCell
        //let beer = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Beer
        //print("made it to here")
        let beer = listOfBeers[indexPath.row]
        let brewer = listOfBrewers[indexPath.row]
        
        
        beerCell.beerName.text = beer
        beerCell.brewery.text = brewer
        
        return beerCell

    }
    func showEditor() {
        let beerEditor = storyboard!.instantiateViewControllerWithIdentifier("BeerEditor") as! BeerEditorVC
        //beerEditor.delegate = self
        navigationController?.pushViewController(beerEditor, animated: true)
    }
}
