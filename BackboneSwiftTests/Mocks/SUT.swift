//
//  File.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 25/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

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
}
extension Fetchable where Self: VideoSUT {
    
    public func fetch(_ options: HttpOptions? = nil) -> Promise<ResponseTuple> {
        
        return Promise(resolvers: { (fulfill, reject) in
            
            fetch(options, onSuccess: { (response) in
                fulfill(response)
                }, onError: { (error) in
                    reject(error)
            })
        })
    }
    
    
    public func fetch(_ options:HttpOptions? = nil, onSuccess: @escaping (ResponseTuple) ->Void , onError:@escaping (BackboneError)->Void){
        
        guard let feedURL = url  else {
            debugPrint("Collections must have an URL, fetch cancelled")
            onError(.invalidURL)
            return
        }
        processOptions(feedURL, inOptions: options  , complete: { [weak self] (options, url) in
            self?.synch(self!, modelURL:url, method: .get, options: options,onSuccess: onSuccess, onError: onError)
            })
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
