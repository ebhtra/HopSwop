//
//  SwopBeerVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/16/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import MapKit

class SwopBeerVC: UIViewController, SentMessageDelegate {
    
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
        
        if beer.userOwner == User.thisUser {
            edit(beer)
        } else {
            sendMsg(beer)
        }
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
        freshnessLabel.text = beer.freshDate
        ownerLabel.text = beer.userOwner!.username
        notesView.text = beer.descrip
        
        notesView.editable = false
        
        if beer.userOwner == User.thisUser {
            msgButton.setTitle("Edit your beer details", forState: .Normal)
        }
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
            
        } else {
            beerPin!.annotation = annotation
        }
        beerPin!.pinTintColor = AppDelegate.spruce
        
        return beerPin!
    }
    
    func showLocation() {
        
        pin.coordinate = CLLocationCoordinate2DMake(beer.latitude, beer.longitude)
        beerLocMap.addAnnotation(pin)
    }
    
    func zoomToBeer() {
        
        beerLocMap.setRegion(MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: true)
    }
    
    func edit(beer: Beer) {
        
        let editor = storyboard?.instantiateViewControllerWithIdentifier("BeerEditor") as! BeerEditorVC
        editor.currentBeer = beer
        editor.editingBeer = true
        
        navigationController?.pushViewController(editor, animated: true)
    }
    
    func sendMsg(beer: Beer) {
        
        let messageWriter = storyboard?.instantiateViewControllerWithIdentifier("SendMessage") as! SendMessageVC
        messageWriter.toUser = beer.userOwner!
        messageWriter.sentMsgDelegate = self
        
        navigationController?.pushViewController(messageWriter, animated: true)
    }
    
    // MessageWasSentDelegate protocol:
    func msgWasSent() {
        // popVC or stay here?
        dispatch_async(dispatch_get_main_queue()) {
            self.displayGenericAlert("Message was sent.", message: "")
        }
    }
}
