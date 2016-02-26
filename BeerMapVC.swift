//
//  BeerMapVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/3/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class BeerMapVC: UIViewController, NSFetchedResultsControllerDelegate, MKMapViewDelegate {
    
    let ArchiveRegionKey = "allBeerRegionArchive"
    
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var beerMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("number of objects in sharedContext = \(sharedContext.registeredObjects.count)")
        
        //set map to last region and zoom
        restoreMapRegion(beerMap, archiveString: ArchiveRegionKey, animated: true)
        
        topOffBeers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let button = parentViewController?.navigationItem.rightBarButtonItem
        button!.target = self
        button?.action = "topOffBeers"
        
        restoreMapRegion(beerMap, archiveString: ArchiveRegionKey, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //keep current region and zoom level
        saveMapRegion(beerMap, archiveString: ArchiveRegionKey)
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    var tempContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().tempContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Beers")
        
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.tempContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()

    
    func topOffBeers() {
        
        // store a batch of beers from the Parse API and load them into map
        ParseClient.sharedInstance.refreshBeers() { success in
            if success {
                dispatch_async(dispatch_get_main_queue()) { _ in
                    self.loadPins()
                }
            }
        }
        print("number of objects in sharedContext = \(sharedContext.registeredObjects.count)")
        print(sharedContext.registeredObjects)
        print("number of objects in tempContext = \(tempContext.registeredObjects.count)")
    }
    
    func loadPins() {
        print("about to load pins")
        // begin by removing old pins
        let pinList = beerMap.annotations
        beerMap.removeAnnotations(pinList)
        annotations = []
        
        // rebuild the array of pins from scratch
        for beer in BeerList.menu {
            let lat = CLLocationDegrees(beer.latitude)
            let long = CLLocationDegrees(beer.longitude)
            
            // Build a CL coordinate
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Create the annotation and set its coordinate,
            //      title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = beer.beerName
            annotation.subtitle = beer.brewer
            
            // Add to the array of annotations
            annotations.append(annotation)
        }
        // When the array is complete,  add the annotations to the map.
        beerMap.addAnnotations(annotations)
    }
    
    // MARK: - MKMapViewDelegate
    
    // Create an accessory view to display Beer name and brewer upon pin tap.
    //    User can then tap the accessory view to see more details and send msg to the owner.
    //      This is based on the Udacity "Pin Sample" app:
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = AppDelegate.spruce
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // delegate method called upon user tapping accessory view,
    //    pushing a SwopBeerVC where user can see beer details and contact owner
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            
            let ind = annotations.indexOf(annotationView.annotation as! MKPointAnnotation)
            
            let chosenBeer = BeerList.menu[ind!]
            
            let detesVC = storyboard?.instantiateViewControllerWithIdentifier("SwopperScene") as! SwopBeerVC
            detesVC.beer = chosenBeer
            
            navigationController?.pushViewController(detesVC, animated: true)
        }
    }
    

}
