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
        static let BrewDBID = "brewDbId"
        static let ParseID = "parseId"
        static let Lat = "latitude"
        static let Lon = "longitude"
        static let Name = "beerName"
        static let Brewer = "brewer"
        static let Vessel = "vessel"
        static let BornOn = "bornOn"
        static let DrinkDate = "drinkDate"
        static let Owner = "owner"
        static let Watcher = "watcher"
    }
    
   
    @NSManaged var descrip: String
    @NSManaged var brewDbId: String
    @NSManaged var parseId: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var beerName: String
    @NSManaged var brewer: String
    @NSManaged var vessel: String
    @NSManaged var bornOn: Bool  // can't use optional Bool for this property
    @NSManaged var drinkDate: String
    @NSManaged var owner: User?
    @NSManaged var watcher: User?
    
    
    
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
    init(dict: [String: AnyObject?], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Beer", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        
        latitude = dict[Keys.Lat] as! Double
        longitude = dict[Keys.Lon] as! Double
        brewDbId = dict[Keys.BrewDBID] as! String
        descrip = dict[Keys.Descrip] as! String
        beerName = dict[Keys.Name] as! String
        brewer = dict[Keys.Brewer] as! String
        vessel = dict[Keys.Vessel] as! String
        bornOn = dict[Keys.BornOn] as! Bool
        drinkDate = dict[Keys.DrinkDate] as! String
        parseId = dict[Keys.ParseID] as! String
        owner = dict[Keys.Owner] as? User
        watcher = dict[Keys.Watcher] as? User
        
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
