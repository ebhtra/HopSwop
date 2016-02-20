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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let controller = (tableView == swopTable) ? swoppedResultsController : watchedResultsController
        
        return controller.sections?[section].numberOfObjects ?? 0
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
    }
     // TODO: -- add editable/deletable by swipe for swop list
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete && tableView == watchTable {
            let beer = watchedResultsController.objectAtIndexPath(indexPath) as! Beer
            sharedContext.deleteObject(beer)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == watchTable {
            let watchbeer = watchedResultsController.objectAtIndexPath(indexPath) as! Beer
            let detesVC = storyboard?.instantiateViewControllerWithIdentifier("beerDetail") as! BeerDetailVC
            detesVC.beer = watchbeer
            navigationController?.pushViewController(detesVC, animated: true)
        }
        if tableView == swopTable {
            let detesVC = storyboard?.instantiateViewControllerWithIdentifier("SwopperScene") as! SwopBeerVC
            detesVC.beer = swoppedResultsController.objectAtIndexPath(indexPath) as! Beer
            navigationController?.pushViewController(detesVC, animated: true)
        }
    }
    
    func showEditor() {
        let beerEditor = storyboard!.instantiateViewControllerWithIdentifier("BeerEditor") as! BeerEditorVC
        navigationController?.pushViewController(beerEditor, animated: true)
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        let table = (controller == swoppedResultsController) ? swopTable : watchTable
        table.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            let table = (controller == swoppedResultsController) ? swopTable : watchTable
            
            switch type {
            case .Insert:
                table.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case .Delete:
                table.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            
            let table = (controller == swoppedResultsController) ? swopTable : watchTable
            
            switch type {
            case .Insert:
                table.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            case .Delete:
                table.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                
            case .Update:
                break
                
            case .Move:
                table.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                table.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        let table = (controller == swoppedResultsController) ? swopTable : watchTable
        table.endUpdates()
    }
    

}
