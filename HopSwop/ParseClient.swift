//
//  ParseClient.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/2/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation

class ParseClient {
    
    // singleton instance stored as static constant
    static let sharedInstance = ParseClient()
    
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    
    // add a new object to Parse
    func postToParseTask(dict: [String: AnyObject], completionHandler: (success: Bool, errorString: String?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Constants.BaseParseRequest)!)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ParseRESTkey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(dict, options: [])
        } catch _ as NSError {
            request.HTTPBody = nil
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: error!.localizedDescription)
            } else {
                
                // parse the results
                let results = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                // use presence of "createdAt" key as a test of success
                if let _ = results["createdAt"] as? String {
                    completionHandler(success: true, errorString: nil)
                } else {
                    completionHandler(success: false, errorString: "Could not create the Object in Parse.")
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
        request.addValue(ParseClient.Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ParseRESTkey, forHTTPHeaderField: "X-Parse-REST-API-Key")
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
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Constants.BaseParseRequest + "/" + objID)!)
        request.HTTPMethod = "PUT"
        request.addValue(ParseClient.Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ParseRESTkey, forHTTPHeaderField: "X-Parse-REST-API-Key")
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

    /* Helper function: Given a dictionary of parameters, convert to a string for a URL.
    Copied and pasted from Jarrod Parkes' Movie Manager app on Udacity */
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