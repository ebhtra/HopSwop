//
//  SwopBeerVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/16/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import MapKit

class SwopBeerVC: UIViewController {
    
    @IBOutlet weak var beerLabel: UILabel!
    @IBOutlet weak var brewerLabel: UILabel!
    @IBOutlet weak var msgButton: UIButton!
    @IBOutlet weak var vesselLabel: UILabel!
    @IBOutlet weak var freshnessLabel: UILabel!
    @IBOutlet weak var drinkByLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var beerLocMap: MKMapView!
    @IBOutlet weak var notesView: UITextView!
    
    @IBAction func msgButtonClick(sender: UIButton) {
        
        //present msg screen or msg tab??
    }
    
    var beer: Beer!
    var pin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackgroundBeer()
        
        showLocation()
        
        beerLabel.text = beer.beerName
        brewerLabel.text = beer.brewer
        vesselLabel.text = beer.vessel
        drinkByLabel.text = beer.bornOn ? "Born on:" : "Drink by:"
        freshnessLabel.text = beer.drinkDate
        ownerLabel.text = beer.owner!.username
        notesView.text = beer.descrip

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        zoomToBeer()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var beerPin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if beerPin == nil {
            
            beerPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            beerPin!.pinTintColor = msgButton.titleColorForState(.Normal)
        } else {
            beerPin!.annotation = annotation
        }
        
        return beerPin!
    }
    
    func showLocation() {
        pin.coordinate = CLLocationCoordinate2DMake(beer.latitude, beer.longitude)
        beerLocMap.addAnnotation(pin)
    }
    func zoomToBeer() {
        beerLocMap.setRegion(MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: true)
    }
}
