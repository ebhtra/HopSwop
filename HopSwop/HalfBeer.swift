//
//  HalfBeer.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/7/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation

// Use this, instead of a temporary managed context,
//      to store the structure of a half-formed Beer object.
//  This is any info needed from breweryDB, and forms half of what will be
//       the Beer object that is stored on Parse and in CoreData,
//          the other half being user-provided specifics

struct HalfBeer {
    var name: String
    var maker: String
    var id: String
    var notes: String
    // var pic: some kind of icon maybe?
    // var story: story behind the brewery maybe?
    
    init(name: String, maker: String, id: String, notes: String) {
        self.name = name
        self.maker = maker
        self.id = id
        self.notes = notes
    }
}