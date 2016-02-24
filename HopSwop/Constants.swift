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
        static let Page = "p"
        static let Category = "type"
        static let ABV = "abv"
    }
    struct Resources {
        static let BeerSearch = "beers/"
        static let Search = "search"
    }
    
    struct Params {
        static let Name = "name"
        static let ABV = "abv"
        static let ID = "id"
        static let Descrip = "description"
    }
}

extension ParseClient {
    
    struct Constants {
        static let BaseParseRequest = "https://api.parse.com/1/classes/"
        static let ParseRESTkey = "z0oWLRSXGxiGa6KdU64DV0lrWKa3SWrpeIvMkvJl"
        
        static let ParseAppID = "QqljByEk29sl0AlCog1B93iATtZnD53JUCSwKGcL"
    }
    struct Methods {
        static let BeerObj = "Beer/"
        static let MsgObj = "Message/"
        static let UserObj = "_User/"
    }

    struct MsgKeys {
        static let MsgTo = "msgTo"
        static let MsgFrom = "msgFrom"
        static let Text = "msgText"
        static let IsNew = "isNew"
    }
    // MARK: - Parameter Keys
    struct ParameterKeys {
        static let Order = "order"
    }
        
}