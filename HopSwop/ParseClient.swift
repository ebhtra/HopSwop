//
//  ParseClient.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/2/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation
import CoreData

class ParseClient {
    
    // singleton instance stored as static constant
    static let sharedInstance = ParseClient()
    
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    let tempContext = CoreDataStackManager.sharedInstance().tempContext
    
    // add a new object to Parse
    func postToParseTask(method: String, parameters: [String: AnyObject], completionHandler: (success: Bool, result: AnyObject?, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseParseRequest + method)!)
        request.HTTPMethod = "POST"
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRESTkey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        } catch _ as NSError {
            request.HTTPBody = nil
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, result: response, errorString: error!.localizedDescription)
            } else {
                
                // parse the results
                let results = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                // use presence of "createdAt" key as a test of success
                if let _ = results["createdAt"] as? String {
                    completionHandler(success: true, result: results, errorString: nil)
                } else {
                    completionHandler(success: false, result: nil, errorString: "Could not create the Object in Parse.")
                }
            }
        }
        task.resume()
        return task
    }
    
    // GET objects from Parse
    func getFromParseTask(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Set the parameters
        let mutableParameters = parameters
        
        // Build the URL and configure the request
        let urlString = Constants.BaseParseRequest + method + ParseClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRESTkey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error!)
            } else {
                let results = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                completionHandler(result: results, error: nil)
            }
        }
        task.resume()
        
        return task
    }

    
    // PUT/update an object on Parse
    func updateOnParseTask(dict: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let objID = dict["objectId"] as! String
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseParseRequest + "/" + objID)!)
        request.HTTPMethod = "PUT"
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRESTkey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(dict, options: [])
        } catch _ as NSError {
            request.HTTPBody = nil
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error!)
            } else {
                let results = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                completionHandler(result: results, error: nil)
            }
        }
        task.resume()
        
        return task
    }
    
    // DELETE an object from Parse
    func deleteFromParseTask(method: String, objectId: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let urlString = Constants.BaseParseRequest + method + objectId
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRESTkey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error!)
            } else {
                let results = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                completionHandler(result: results, error: nil)
            }
        }
        task.resume()
        
        return task
    }


    /* Helper function: Given a dictionary of parameters, convert to a string for a URL.
    Copied and pasted from Jarrod Parkes' Movie Manager app on Udacity, since the Parse REST API docs examples are for Python
    */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

}