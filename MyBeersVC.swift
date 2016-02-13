//
//  MyBeersVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/3/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import CoreData

class MyBeersVC: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var swopTable: UITableView!
    @IBOutlet weak var watchTable: UITableView!
    
    var listOfBeers = [String]()
    var listOfBrewers = [String]()
    
    var watchbeerlist = [HalfBeer]()
    var swopbeerlist = [Beer]()
    
    let currUser = PFUser.currentUser()!
    
    override func viewDidLoad() {
        
        showBackgroundBeer()
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
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    lazy var watchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Beer")
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "watcher == %@", self.currUser)
        
        let watchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return watchedResultsController
    }()
    
    lazy var swoppedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Beer")
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "owner == %@", self.currUser )
        
        let swoppedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return swoppedResultsController
    }()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == swopTable {
            return swopbeerlist.count
        } else {
            return watchbeerlist.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let beerCell = tableView.dequeueReusableCellWithIdentifier("basicCell")!
        
        if tableView == swopTable {
            let beer = swoppedResultsController.objectAtIndexPath(indexPath) as! Beer
            print("made it to here")
            beerCell.textLabel?.text = beer.beerName
            beerCell.detailTextLabel?.text = beer.brewer
        }
            
        if tableView == watchTable {
            let beer = watchedResultsController.objectAtIndexPath(indexPath) as! Beer
            print("oh yeah?? made it to here")
            beerCell.textLabel?.text = beer.beerName
            beerCell.detailTextLabel?.text = beer.brewer
        }
            
            // add detail callout with chevron on right of cells
            // add editable/deletable with swipe
            //  this type of cell may be same as for beerlistVC later
        
        return beerCell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == watchTable {
            let watchbeer = watchbeerlist[indexPath.row]
            let detesVC = storyboard?.instantiateViewControllerWithIdentifier("beerDetail") as! BeerDetailVC
            detesVC.beer = watchbeer
            navigationController?.pushViewController(detesVC, animated: true)
        }
    }
    
    func showEditor() {
        let beerEditor = storyboard!.instantiateViewControllerWithIdentifier("BeerEditor") as! BeerEditorVC
        navigationController?.pushViewController(beerEditor, animated: true)
    }
}
