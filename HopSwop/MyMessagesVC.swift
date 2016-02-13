//
//  MyMessagesVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/5/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import CoreData

class MyMessagesVC: BeerLoginController, NSFetchedResultsControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        
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
        button?.action = "refreshMessages"
    }
    func refreshMessages() {
        print("hola")
    }

}