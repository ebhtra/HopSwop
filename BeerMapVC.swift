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

class BeerMapVC: UIViewController, MKMapViewDelegate {
    
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var beerMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // store a batch of students from the Parse API and load them into map
       // ParseClient.sharedInstance.refreshBeers() { success in
        //    if success {
        //        self.loadPins()
       //     }
      //  }
    }
       
    func loadPins() {
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
            
            // Add to the array of annotations
            annotations.append(annotation)
        }
        // When the array is complete,  add the annotations to the map.
        beerMap.addAnnotations(annotations)
    }

}
