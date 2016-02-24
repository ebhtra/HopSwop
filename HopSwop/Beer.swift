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
    
    struct Keys {
        
        static let Descrip = "descrip"
        static let BrewDBID = "dbID"
        static let ParseID = "objectId"
        static let Lat = "latitude"
        static let Lon = "longitude"
        static let Name = "beerName"
        static let Brewer = "brewer"
        static let Vessel = "vessel"
        static let BornOn = "bornOn"
        static let DrinkDate = "freshDate"
        static let ParseOwner = "owner"
        static let Watcher = "watcher"
        static let UserOwner = "userOwner"
    }
    
   
    @NSManaged var descrip: String
    @NSManaged var dbID: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var beerName: String
    @NSManaged var brewer: String
    @NSManaged var vessel: String
    @NSManaged var bornOn: Bool  // can't use optional Bool for this property
    @NSManaged var freshDate: String
    
    @NSManaged var objectId: String? // Parse objectId of Beer
    @NSManaged var owner: String?  // Parse objectId of Beer owner
    @NSManaged var userOwner: User?  // ManagedObject User who owns Beer
    @NSManaged var watcher: User?  // ManagedObject User watching beer-- This will be currentUser for now
    
    
    
    // MKMapView will not add MKAnnotations from fetched CoreData Pins without a coordinate getter:
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Beer", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
    }
    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Beer", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        
        latitude = dict[Keys.Lat] as! Double
        longitude = dict[Keys.Lon] as! Double
        dbID = dict[Keys.BrewDBID] as! String
        descrip = dict[Keys.Descrip] as! String
        beerName = dict[Keys.Name] as! String
        brewer = dict[Keys.Brewer] as! String
        vessel = dict[Keys.Vessel] as! String
        bornOn = dict[Keys.BornOn] as! Bool
        freshDate = dict[Keys.DrinkDate] as! String
        
    }
    
}
