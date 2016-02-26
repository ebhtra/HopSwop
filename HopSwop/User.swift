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
    
    static let sharedUser = User()
    
    static var thisUser: User {
        if let me = getUniqueUser(PFUser.currentUser()!.objectId!) {
            return me
            
        } else {  // User's first time using the app:
            
         return User(dict: [Keys.ParseID: PFUser.currentUser()!.objectId!,
         Keys.Username: PFUser.currentUser()!.username!], context: sharedContext)
        }
    }
    
    static let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
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
    
    class func getUniqueUser(parseID: String) -> User? {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "parseId == %@", parseID)
        do {
            if let theUser = try sharedContext.executeFetchRequest(fetchRequest) as? [User] {
            
                if theUser.count > 0 {
                    print("existing User there: \(theUser[0])")
                    return theUser[0]
                }
            }
        } catch let error as NSError {
            print(error)
        }
        var name: String?
        ParseClient.sharedInstance.getUsernameFromId(parseID) { username, error in
         
            if let err = error {
                print("error getting username from Parse: \(err)")
            }
            if let user = username {
                name = user
            }
        }
        if let n = name {
            return User(dict: [Keys.ParseID: parseID,
                Keys.Username: n], context: sharedContext)
        }
        return nil
    }
}