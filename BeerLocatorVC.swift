//
//  BeerLocatorVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/9/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import MapKit


protocol LocationDelegate {
    func setBeerLoc(toLoc: CLLocationCoordinate2D?)
}

class BeerLocatorVC: BeerLoginController, MKMapViewDelegate {
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var setSaveButton: UIButton!
    @IBOutlet weak var globalMap: MKMapView!
    
    var newPin = MKPointAnnotation()
    var locDelegate: LocationDelegate!
    var mapTap = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set map to last region and zoom
        restoreMapRegion(true)
        
        mapTap.addTarget(self, action: Selector("placePin:"))
        mapTap.minimumPressDuration = 0.1
        view.addGestureRecognizer(mapTap)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //set map to last region and zoom
        restoreMapRegion(true)
    }
    override func viewWillDisappear(animated: Bool) {
        //keep current region and zoom level
        saveMapRegion()
    }
    
    @IBAction func setSave(sender: UIButton) {
        locDelegate.setBeerLoc(newPin.coordinate)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func placePin(recognizer: UIGestureRecognizer) {
        let point = recognizer.locationInView(globalMap)
        let coord = globalMap.convertPoint(point, toCoordinateFromView: globalMap)
        newPin.coordinate = coord
      
        globalMap.addAnnotation(newPin)
        setSaveButton.setTitle("Save this location", forState: .Normal)
    }
    
   
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == .Ending {
            newPin.coordinate = (view.annotation?.coordinate)!
        }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var beerPin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if beerPin == nil {
           
            beerPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            beerPin!.pinTintColor = setSaveButton.titleColorForState(.Normal)
            beerPin!.draggable = true
        } else {
            beerPin!.annotation = annotation
        }
        
        return beerPin
    }

    
    // MARK: -- Setting and saving the UI state
    //
    // This code is copied from Udacity's MemoryMap app in the ios-persistence course
    
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        return url!.URLByAppendingPathComponent("mapRegionArchive").path!
    }

    
    func saveMapRegion() {
        
        // Place the "center" and "span" of the map into a dictionary
        // The "span" is the width and height of the map in degrees.
        // It represents the zoom level of the map.
        
        let dictionary = [
            "latitude" : globalMap.region.center.latitude,
            "longitude" : globalMap.region.center.longitude,
            "latitudeDelta" : globalMap.region.span.latitudeDelta,
            "longitudeDelta" : globalMap.region.span.longitudeDelta
        ]
        
        // Archive the dictionary into the filePath
        NSKeyedArchiver.archiveRootObject(dictionary, toFile: filePath)
    }
    
    func restoreMapRegion(animated: Bool) {
       
        // if we can unarchive a dictionary, we will use it to set the map back to its
        // previous center and span
        if let regionDictionary = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String : AnyObject] {
            
            let longitude = regionDictionary["longitude"] as! CLLocationDegrees
            let latitude = regionDictionary["latitude"] as! CLLocationDegrees
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let longitudeDelta = regionDictionary["latitudeDelta"] as! CLLocationDegrees
            let latitudeDelta = regionDictionary["longitudeDelta"] as! CLLocationDegrees
            let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            
            let savedRegion = MKCoordinateRegion(center: center, span: span)
            
            globalMap.setRegion(savedRegion, animated: animated)
        }
    }

    
    
}
