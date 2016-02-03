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
        
        // no method to add here:
        let method = "Beer"
        
        getFromParseTask(method, parameters: params) { jsonResult, error in
            if error != nil {
                completion(success: false)
            } else {
                // An array of beers was returned from Parse. Store each one as a Beer struct in BeerList
                if let results = jsonResult.valueForKey("results") as? [[String: AnyObject]] {
                    for dict in results {
                        let newBeer = Beer(dict: dict, context: self.sharedContext)
                        BeerList.menu.append(newBeer)
                    }
                    completion(success: true)
                }
            }
        }
    }
}