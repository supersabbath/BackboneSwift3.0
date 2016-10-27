//
//  TestDataSource.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 26/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import UIKit

@testable import BackboneSwift
import SwiftyJSON
struct TestDataSource {

    let jsonBasicEntity:[String:Any] = ["dummyString":"dummyValue", "dummyJuanCarlos":"jayc" , "dummyBoolean":true]
    
    let jsonComplexEntity:[String:Any] = [ "name":"john" , "intValue":23 , "dictionary":["setting":"value"] ,"array":["1","3","2"], "backboneModel":["dummyString":"dummyValue", "dummyJuanCarlos":"jayc" ], "yes":true]
    
    func jsonForTwoSubClassingLeves() -> JSON {
        var firstLevel = jsonComplexEntity
        firstLevel["customValue"] = "value"
        return JSON(firstLevel)
    }
}
