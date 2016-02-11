//
//  HalfBeer.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/7/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation

// Using this, instead of a temporary managed context,
//      to store the structure of a half-formed Beer object.
//  Also may come in handy for storing watchlist/favorite beers

struct HalfBeer {
    var name: String
    var maker: String
    var id: String
    var notes: String
    
    init(name: String, maker: String, id: String, notes: String) {
        self.name = name
        self.maker = maker
        self.id = id
        self.notes = notes
    }
}