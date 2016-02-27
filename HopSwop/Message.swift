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
    
    struct Keys {
        static let MsgTo = "msgTo"
        static let MsgFrom = "msgFrom"
        static let MsgBody = "msgText"
        static let IsNew = "isNew"
        static let CreatedAt = "createdAt"
        static let ParseID = "objectId"
    }
    
    @NSManaged var msgTo: User
    @NSManaged var msgFrom: User
    @NSManaged var msgText: String
    @NSManaged var createdAt: String
    @NSManaged var objectId: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Message", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        print("dict for init of message: \(dict)")
        
        objectId = dict[Keys.ParseID] as! String
        msgFrom = dict[Keys.MsgFrom] as! User
        msgTo = dict[Keys.MsgTo] as! User
        msgText = dict[Keys.MsgBody] as! String
        createdAt = dict[Keys.CreatedAt] as! String
    }

    
}