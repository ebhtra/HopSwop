//
//  BeerListVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/3/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import CoreData

class BeerListVC: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var beerTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackgroundBeer()
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        fetchedResultsController.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let button = parentViewController?.navigationItem.rightBarButtonItem
        button!.target = self
        button?.action = "refreshList"
    }
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Beer")
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "owner != nil")
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let ReuseIdentifier = "beerCell"
            
            let beer = fetchedResultsController.objectAtIndexPath(indexPath) as! Beer
            
            let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier) as! BeerCell
            
            configureCell(cell, beer: beer)
            
            return cell
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            switch (editingStyle) {
            case .Delete:
                
                // Here we get the actor, then delete it from core data
                let beer = fetchedResultsController.objectAtIndexPath(indexPath) as! Beer
                sharedContext.deleteObject(beer)
                CoreDataStackManager.sharedInstance().saveContext()
                
            default:
                break
            }
    }
    
    // MARK: - Fetched Results Controller Delegate
   
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        beerTable.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                beerTable.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case .Delete:
                beerTable.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
    }
    
    //
    // This is the most interesting method. Take particular note of way the that newIndexPath
    // parameter gets unwrapped and put into an array literal: [newIndexPath!]
    //
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            
            switch type {
            case .Insert:
                beerTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            case .Delete:
                beerTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                
            case .Update:
                let cell = beerTable.cellForRowAtIndexPath(indexPath!) as! BeerCell
                let beer = controller.objectAtIndexPath(indexPath!) as! Beer
                self.configureCell(cell, beer: beer)
                
            case .Move:
                beerTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                beerTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        beerTable.endUpdates()
    }

    func refreshList() {
        
    }
    func configureCell(cell: BeerCell, beer: Beer) {
        cell.brewery.text = beer.brewer
        cell.beerName.text = beer.beerName
    }

}

