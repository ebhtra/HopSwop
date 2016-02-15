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
    
    static let thisUser = User(dict: [Keys.ParseID: PFUser.currentUser()!.objectId!,
        Keys.Username: PFUser.currentUser()!.username!], context: CoreDataStackManager.sharedInstance().managedObjectContext)
    
    struct Keys {
        static let ParseID = "parseId"
        static let Username = "username"
        static let GotMsg = "gotMsg"
        static let SentMsg = "sentMsg"
        static let Watchers = "watchBeer"
        static let Swoppers = "swopBeer"
    }
    
    @NSManaged var parseId: String
    @NSManaged var username: String
    @NSManaged var gotMsg: [Message]
    @NSManaged var sentMsg: [Message]
    @NSManaged var watchBeer: [Beer]
    @NSManaged var swopBeer: [Beer]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        parseId = dict[Keys.ParseID] as! String
        username = dict[Keys.Username] as! String
    }
}