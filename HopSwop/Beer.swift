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
    
    @NSManaged var createdAt: NSDate
    @NSManaged var notInDB: Bool
    @NSManaged var descrip: String
    @NSManaged var objectId: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var updatedAt: NSDate
    
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
        
        createdAt = dict["createdAt"] as! NSDate
        latitude = dict["latitude"] as! Double
        longitude = dict["longitude"] as! Double
        objectId = dict["objectId"] as! String
        updatedAt = dict["updatedAt"] as! NSDate
        notInDB = dict["notInDB"] as! Bool
        descrip = dict["descrip"] as? String ?? ""
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
