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
    
    let currUser = User.thisUser
    
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
        do {
            try watchedResultsController.performFetch()
        } catch {
            print(error)
        }
        do {
            try swoppedResultsController.performFetch()
        } catch {
            print(error)
        }
        
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
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "beerName", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "watcher == %@", User.thisUser)
        
        let watchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        watchedResultsController.delegate = self
        return watchedResultsController
    }()
    
    lazy var swoppedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Beer")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "beerName", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "owner == %@", User.thisUser)
        
        let swoppedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
    
        swoppedResultsController.delegate = self
        return swoppedResultsController
    }()
    
    // Andrew Bancroft's post saved the day on nil result for sections
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == swopTable {
            if let sections = swoppedResultsController.sections {
                let currentSection = sections[section]
                return currentSection.numberOfObjects
            }
            return 0   // no results yet so no sections
            
        } else {  // tableView is watchTable
            if let sections = watchedResultsController.sections {
                let currentSection = sections[section]
                return currentSection.numberOfObjects
            }
            return 0   // no results yet so no sections
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == swopTable {
            let swopCell = tableView.dequeueReusableCellWithIdentifier("mySwopCell")!
            let beer = swoppedResultsController.objectAtIndexPath(indexPath) as! Beer
            print("made it to here")
            swopCell.textLabel?.text = beer.beerName
            swopCell.detailTextLabel?.text = beer.brewer
            
            return swopCell
            
        } else {     // tableView is watchlist
            
            let beerCell = tableView.dequeueReusableCellWithIdentifier("basicCell")!
            let beer = watchedResultsController.objectAtIndexPath(indexPath) as! Beer
            print("oh yeah?? made it to here")
            beerCell.textLabel?.text = beer.beerName
            beerCell.detailTextLabel?.text = beer.brewer
            
            return beerCell
        }
        
            // TODO: -- add editable/deletable with swipe
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == watchTable {
            let watchbeer = watchedResultsController.objectAtIndexPath(indexPath) as! Beer
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
