//
//  User.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/11/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    
    @NSManaged var parseId: String
    @NSManaged var username: String
    @NSManaged var gotMsg: Message?
    @NSManaged var sentMsg: Message?
    @NSManaged var watchBeer: Beer?
    @NSManaged var swopBeer: Beer?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        parseId = dict["parseId"] as! String
        username = dict["username"] as! String
        gotMsg = dict["gotMsg"] as? Message
        sentMsg = dict["sentMsg"] as? Message
        watchBeer = dict["watchBeer"] as? Beer
        swopBeer = dict["swopBeer"] as? Beer
    }
}