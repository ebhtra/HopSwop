//
//  Beer.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/2/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Beer: NSManagedObject, MKAnnotation {
    
   
    @NSManaged var descrip: String
    @NSManaged var objectId: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var beerName: String
    @NSManaged var brewer: String
    @NSManaged var owner: User?
    @NSManaged var watcher: User?
    @NSManaged var vessel: String?
    @NSManaged var bornOn: NSNumber?  // can't use optional Bool for this property
    @NSManaged var drinkDate: NSDate?
    
    
    
    // MKMapView will not add MKAnnotations from fetched CoreData Pins without a coordinate getter:
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Beer", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        
        latitude = dict["latitude"] as! Double
        longitude = dict["longitude"] as! Double
        objectId = dict["objectId"] as! String
        descrip = dict["descrip"] as! String
        beerName = dict["beerName"] as! String
        brewer = dict["brewer"] as! String
        owner = dict["owner"] as? User
        watcher = dict["watcher"] as? User
        vessel = dict["vessel"] as? String
        bornOn = dict["bornOn"] as? Bool
        drinkDate = dict["drinkDate"] as? NSDate
        
        
    }
    /*
    func setCoordinate(toPoint: CLLocationCoordinate2D) {
        //To comply with KVO in order to drag a pin before dropping it
        willChangeValueForKey("coordinate")
        latitude = toPoint.latitude
        longitude = toPoint.longitude
        didChangeValueForKey("coordinate")
    }
   */
}
