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
        params[ParseClient.ParameterKeys.Order] = "-updatedAt"
        
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
                            if owner != User.thisUser.parseId { // so it's not the user's beer
                                let newBeer = Beer(dict: dict, context: self.tempContext)
                                newBeer.objectId = dict[Beer.Keys.ParseID] as? String
                                newBeer.owner = dict[Beer.Keys.ParseOwner] as? String
                                self.getUsernameFromId(newBeer.owner!) { name, error in
                                    if let newName = name {
                                        dispatch_async(dispatch_get_main_queue()) {
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
        dict[ParseClient.MsgKeys.IsNew] = false
        dict[ParseClient.MsgKeys.MsgFrom] = PFUser.currentUser()?.objectId
        dict[ParseClient.MsgKeys.MsgTo] = to.parseId
        dict[ParseClient.MsgKeys.Text] = msg

        let method = ParseClient.Methods.MsgObj
        
        postToParseTask(method, parameters: dict) { success, result, error in
            
            if success {
                print(result)
                completion(success: true, errorString: nil)
            } else {
                print(error)
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
        
        ParseClient.sharedInstance.getFromParseTask(ParseClient.Methods.UserObj + userParseId, parameters: [:]) { results, nsErr in
            if nsErr != nil {
                completion(name: nil, errorString: nsErr!.localizedDescription)
                
            } else {
                //print("user search task results = \(results)")
                let user = results[User.Keys.Username] as? String
                completion(name: user, errorString: nil)
            }
            
        }
    }
}