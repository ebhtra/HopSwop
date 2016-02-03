//
//  Message.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/2/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation
import CoreData

class Message: NSManagedObject {
    
    @NSManaged var msgTo: PFUser
    @NSManaged var msgFrom: PFUser
    @NSManaged var text: String
    @NSManaged var createdAt: NSDate
    @NSManaged var objectId: Int
    @NSManaged var updatedAt: NSDate
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Message", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        createdAt = dict["createdAt"] as! NSDate
        objectId = dict["objectId"] as! Int
        updatedAt = dict["updatedAt"] as! NSDate
        msgFrom = dict["msgFrom"] as! PFUser
        msgTo = dict["msgTo"] as! PFUser
        text = dict["text"] as! String
    }

    
}