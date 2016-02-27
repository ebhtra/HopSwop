//
//  MyMessagesVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/5/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import CoreData

class MyMessagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var msgTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackgroundBeer()
        
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        //fetchRequest.predicate = NSPredicate(format: "msgFrom == %@", User.thisUser)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let button = parentViewController?.navigationItem.rightBarButtonItem
        button!.target = self
        button?.action = "refreshMessageBoard"
        
        refreshMsgs() // or let user do it with button?

    }
    
    func refreshMsgs() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func refreshMessageBoard() {
        // query Parse for any new messages to the User, persist them to the store, and refresh the board
        ParseClient.sharedInstance.refreshMessages() { error in
            if let err = error {
                self.displayGenericAlert("Sorry, but the message board didn't refresh--", message: err)
            } else {
                self.refreshMsgs()
            }
        }
    }
    
    // MARK: - UITableView Delegate and DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MsgCell") as! MessageCell
        let msg = fetchedResultsController.objectAtIndexPath(indexPath) as! Message
        cell.messageTextLabel.text = msg.msgText
        if msg.msgFrom == User.thisUser {
            cell.toFromLabel.text = "TO"
            cell.otherUserLabel.text = msg.msgTo.username
        } else {
            cell.otherUserLabel.text = msg.msgFrom.username
            cell.otherUserLabel.textColor = UIColor.whiteColor()
            cell.otherUserLabel.backgroundColor = cell.toFromLabel.textColor
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let msg = fetchedResultsController.objectAtIndexPath(indexPath) as! Message
        
        let msgVC = storyboard?.instantiateViewControllerWithIdentifier("messageVC") as! MessageDetailVC
        msgVC.message = msg
        
        navigationController?.pushViewController(msgVC, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let msg = fetchedResultsController.objectAtIndexPath(indexPath) as! Message
            sharedContext.deleteObject(msg)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        msgTable.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                msgTable.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case .Delete:
                msgTable.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            
            switch type {
            case .Insert:
                msgTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            case .Delete:
                msgTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                
            case .Update:
                break
                
            case .Move:
                msgTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                msgTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        msgTable.endUpdates()
    }

}