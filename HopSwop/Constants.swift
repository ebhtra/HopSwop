//
//  Constants.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/2/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation

extension BreweryDbClient {
    
    struct Constants {
        static let ApiKey = "d6adf3edd3cac4fca45467b41488f57f"
        static let BaseUrl = "http://api.brewerydb.com/v2/"
    }
    struct Keys {
        static let ID = "id"
        static let Query = "q"
        static let BreweryToo = "withBreweries"
    }
    struct Resources {
        static let BeerSearch = "beers/"
        static let Search = "search"
    }
    
}

extension ParseClient {
    
    struct Constants {
        static let BaseParseRequest = "https://api.parse.com/1/classes/Beer"
        static let ParseRESTkey = "z0oWLRSXGxiGa6KdU64DV0lrWKa3SWrpeIvMkvJl"
        static let ParseAppID = "QqljByEk29sl0AlCog1B93iATtZnD53JUCSwKGcL"
    }
    struct Methods {
        static let BeerObj = "Beer"
        static let MsgObj = "Message"
        static let UserObj = "_User"
    }
    // MARK: - Parameter Keys
    struct ParameterKeys {
        static let Order = "order"
    }
        
}