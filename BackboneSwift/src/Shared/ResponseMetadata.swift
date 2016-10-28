//
//  ResponseMetadata.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 28/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import UIKit

public protocol  ResponseAsociatedData  {
    
    var response: HTTPURLResponse? { get set }
    var isCacheResult:Bool { get set }
    var failed:Bool { get set }
}


public struct ResponseMetadata  : ResponseAsociatedData{
    
    public var response: HTTPURLResponse?
    public var isCacheResult = false
    public var failed = false
    public var httpStatus : Int {
        return response?.statusCode ?? Int.max
    }
    
    init(fromCache:Bool){
        isCacheResult = fromCache
    }
    
    init(httpResponse:HTTPURLResponse, fromCache:Bool){
        response = httpResponse
        isCacheResult = fromCache
    }
    
}
