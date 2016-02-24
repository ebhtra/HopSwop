//
//  ParseBeer.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/24/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation

struct ParseBeer {
    var descrip: String
    var dbID: String
    var latitude: Double
    var longitude: Double
    var beerName: String
    var brewer: String
    var vessel: String
    var bornOn: Bool
    var freshDate: String
    var objectId: String? // Parse objectId of Beer
    var owner: String?  // Parse objectId of Beer owner
    
    init(dict: [String: AnyObject]) {
        latitude = dict[Beer.Keys.Lat] as! Double
        longitude = dict[Beer.Keys.Lon] as! Double
        dbID = dict[Beer.Keys.BrewDBID] as! String
        descrip = dict[Beer.Keys.Descrip] as! String
        beerName = dict[Beer.Keys.Name] as! String
        brewer = dict[Beer.Keys.Brewer] as! String
        vessel = dict[Beer.Keys.Vessel] as! String
        bornOn = dict[Beer.Keys.BornOn] as! Bool
        freshDate = dict[Beer.Keys.DrinkDate] as! String
        objectId = dict[Beer.Keys.ParseID] as? String
        owner = dict[Beer.Keys.ParseOwner] as? String
    }
}