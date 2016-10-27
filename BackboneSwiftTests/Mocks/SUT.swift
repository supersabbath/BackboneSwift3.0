//
//  File.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 25/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation
import SwiftyJSON

@testable import BackboneSwift
/**
 SUTs:  TestClass and VideoSUT
 */
open class JayCDumpClass : Model {
     var dummyString:String?
     var dummyJuanCarlos:String?
     var dummyBoolean: Bool = false
}

open class VideoSUT : Model {
    
    var uri:String?
    var language:String?
    
    open override func parse(_ response: JSON) {
        if let videdDic = response["page"]["items"].arrayValue.first {
          super.parse(videdDic)
        }
    }
    public override func fetch(_ options: HttpOptions?, onSuccess: @escaping (ResponseTuple) -> Void, onError: @escaping (BackboneError) -> Void) {
        
    }
    
}


open class DummyClassWithSubclass : Model {
    var name:String?
    var intValue:String?
    var dictionary: [String:AnyObject]?
    var array:[AnyObject]?
    var backboneModel : JayCDumpClass?
}

open class TwoLevelsOfSubclass : DummyClassWithSubclass {
    var customValue:String?
}
