//
//  ParseConvenience.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/3/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func refreshBeers(completion: (success: Bool) -> Void) {
        // build parameters array
        var params = [String: AnyObject]()
        params[ParseClient.ParameterKeys.Order] = "-updatedAt" // probably not needed, since the only data displayed directly from API calls, as opposed to CoreData fetches, is map points
        
        // add method
        let method = ParseClient.Methods.BeerObj
        
        getFromParseTask(method, parameters: params) { jsonResult, error in
            if error != nil {
                completion(success: false)
            } else {
                // An array of beers was returned from Parse. Store each one as a Beer in BeerList.swift
                if let results = jsonResult.valueForKey("results") as? [[String: AnyObject]] {
                    
                    // init Beers on main queue since that's where MOC's exist
                    self.sharedContext.performBlockAndWait() {
                        BeerList.menu = [Beer]()
                        for dict in results {
                            let owner = dict["owner"] as! String
                            if owner != PFUser.currentUser()?.objectId { // so it's not the user's beer. (maybe should filter this on Parse query instead?)
                                let newBeer = Beer(dict: dict, context: self.tempContext)
                                newBeer.objectId = dict[Beer.Keys.ParseID] as? String
                                newBeer.owner = dict[Beer.Keys.ParseOwner] as? String
                                self.getUsernameFromId(newBeer.owner!) { name, error in
                                    if let newName = name {
                                        dispatch_async(dispatch_get_main_queue()) {  // this has to be a bad idea, to create a User in the temp context
                                            newBeer.userOwner = User(dict: [User.Keys.Username: newName, User.Keys.ParseID: newBeer.owner!], context: self.tempContext)
                                        }
                                    } else {
                                        print("massive error--\(error)")
                                    }
                                }
                                BeerList.menu.append(newBeer)
                            }
                        }
                        CoreDataStackManager.sharedInstance().saveContext()
                    }
                    completion(success: true)
                    
                } else {
                    print("no 'results' field was returned from Parse")
                    completion(success: false)
                }
            }
        }
    }
    
    // MARK: - Post a Message to Parse and add the returned Parse properties in handler
    
    func postMessage(to: User, msg: String, completion: (success: Bool, errorString: String?) -> Void) {
        
        var dict = [String: AnyObject]()
        dict[Message.Keys.IsNew] = true
        dict[Message.Keys.MsgFrom] = PFUser.currentUser()?.objectId
        dict[Message.Keys.MsgTo] = to.parseId
        dict[Message.Keys.MsgBody] = msg

        let method = ParseClient.Methods.MsgObj
        
        postToParseTask(method, parameters: dict) { success, result, error in
            
            if success {
                print("post msg to parse result = \(result)")
                let created = result!["createdAt"] as! String
                let obj = result!["objectId"] as! String
                var coreUser: User!
                self.sharedContext.performBlockAndWait() {
                    coreUser = User.getUniqueUser(to.parseId)!
                }
                var coreDict = [String: AnyObject]()
                coreDict[Message.Keys.IsNew] = true
                coreDict[Message.Keys.MsgFrom] = User.thisUser
                coreDict[Message.Keys.MsgTo] = coreUser  // get a uniqueUser in shared context here
                coreDict[Message.Keys.MsgBody] = msg
                coreDict[Message.Keys.CreatedAt] = created
                coreDict[Message.Keys.ParseID] = obj
                
                dispatch_async(dispatch_get_main_queue()) {

                    let _ = Message(dict: coreDict, context: self.sharedContext)
                }
                completion(success: true, errorString: nil)
            } else {
                print("parsePostProbs: \(error)")
                completion(success: false, errorString: error)
            }
        }
        
    }
    
    // MARK: - Post a new Swop Beer to Parse and save to CoreData with extra Parse fields if successful
    
    func postBeer(dict: [String: AnyObject], completion: (success: Bool, errorString: String?) -> Void) {
    
        let method = ParseClient.Methods.BeerObj
        
        postToParseTask(method, parameters: dict) { success, result, error in
            
            if success {
                let postedBeer = Beer(dict: dict, context: CoreDataStackManager.sharedInstance().managedObjectContext)
                
                postedBeer.objectId = result!["objectId"] as? String
                postedBeer.userOwner = User.thisUser
                
                CoreDataStackManager.sharedInstance().saveContext()
                
                completion(success: true, errorString: nil)
                
            } else {
                completion(success: false, errorString: "Couldn't post your beer to the Swop board--\(error)")
            }
        }
    }
    
    func updateSwop(dict: [String: AnyObject], completion: (success: Bool, errorString: String?) -> Void) {
        
        updateOnParseTask(dict) { results, nsErr in
        
            if nsErr != nil {
                print(nsErr!.localizedDescription)
            } else {
                print(results)
               // CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
    
    func getUsernameFromId(userParseId: String, completion: (name: String?, errorString: String?) -> Void) {
        print("getting username, hold on...")
        ParseClient.sharedInstance.getFromParseTask(ParseClient.Methods.UserObj + userParseId, parameters: [:]) { results, nsErr in
            if nsErr != nil {
                print("this fucking error: \(nsErr!.localizedDescription)")
                completion(name: nil, errorString: nsErr!.localizedDescription)
                
            } else {
                
                print("user search task results = \(results)")
                let user = results[User.Keys.Username] as? String
                completion(name: user, errorString: nil)
            }
            
        }
    }
    
    func refreshMessages(completion: (errorString: String?) -> Void) {
        
        var params = [String: AnyObject]()
        params[Message.Keys.MsgTo] = PFUser.currentUser()?.objectId
        params[Message.Keys.IsNew] = true
        
        ParseClient.sharedInstance.getFromParseTask(ParseClient.Methods.MsgObj, parameters: params) { result, nsErr in
            
            if let _ = nsErr {
                print("error in the parse get message call:  \(nsErr!.localizedDescription)")
                completion(errorString: nsErr!.localizedDescription)
                
            } else {
                
                if let results = result.valueForKey("results") as? [[String: AnyObject]] {
                    
                    // init Messages on main queue since that's where MOC's exist
                    self.sharedContext.performBlockAndWait() {
                    
                        for dict in results {
                            
                            var coreDict = [String: AnyObject]()
                                
                            let sender = User.getUniqueUser(dict[Message.Keys.MsgFrom] as! String) // 1st time returns a lightweight User to use as msgFrom
                            
                            coreDict[Message.Keys.MsgFrom] = sender!
                            coreDict[Message.Keys.MsgTo] = User.thisUser
                            coreDict[Message.Keys.MsgBody] = dict[Message.Keys.MsgBody]
                            coreDict[Message.Keys.CreatedAt] = dict[Message.Keys.CreatedAt]
                            coreDict[Message.Keys.ParseID] = dict[Message.Keys.ParseID]
                            print("sender = \(coreDict[Message.Keys.MsgFrom])")
                            
                            let _ = Message(dict: coreDict, context: self.sharedContext)
                        }
                        
                        CoreDataStackManager.sharedInstance().saveContext()
                        
                        completion(errorString: nil)
                    }
                    
                } else {
                    print("no results returned from Parse, and no explanation")
                    completion(errorString: nil)
                }
            }
        }
    }
}