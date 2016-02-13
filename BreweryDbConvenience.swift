//
//  BreweryDbConvenience.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/7/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation

extension BreweryDbClient {
    
    func halfBeerSearch(searchString: String, completionHandler: (result: [HalfBeer]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        let parameters = [BreweryDbClient.Keys.Query: searchString, BreweryDbClient.Keys.BreweryToo: "Y", BreweryDbClient.Keys.Category: "beer"]
        let resource = BreweryDbClient.Resources.Search
        
        let task = taskForResource(resource, parameters: parameters) { JSONResult, error in
           
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                
                if let beerdata = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                    
                    var beerlist = [HalfBeer]()
                    
                    for beer in beerdata {
                        
                        let name = beer["name"] as! String
                        var maker = ""
                        let id = beer["id"] as! String
                        let notes = beer["description"] as? String ?? ""
                        // TODO -- add multiple brewers to one beer display
                        
                        if let brewers = beer["breweries"] as? [[String : AnyObject]] {
                            
                            maker = (brewers[0]["name"] ?? brewers[0]["nameShortDisplay"]) as! String
                            //self.listOfImageUrls.append((brewers[0]["images"]!["icon"] as? String)!)
                            
                        }
                        beerlist.append(HalfBeer(name: name, maker: maker, id: id, notes: notes))
                        //let _ = Beer(beerName: name, context: self.sharedContext)
                        //print(beer)
                    }
                    //CoreDataStackManager.sharedInstance().saveContext()
                    /*
                    // Create an array of Beer instances from the JSON dictionaries
                    self.listOfBeers = beerDictionaries.map() {
                    Beer(dictionary: $0, context: self.temporaryContext)
                    }
                    */
                    // Reload the table on the main thread
                   // dispatch_async(dispatch_get_main_queue()) {
                    //    self.searchTable.reloadData()
                    //}
                    
                    
                    completionHandler(result: beerlist, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "halfBeerSearch parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse halfBeerSearch"]))
                }
            }
        }
        
        return task
    }

    
    
}