//
//  HttpOptions.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 24/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import UIKit

public struct HttpOptions {
    
    
    public var useCache = true
    public var headers:[String:String]?
    public var query:String?
    public var body:[String:AnyObject]?
    public var relativePath:String?
    
    public init(){}
    
    public init (httpHeader:[String:String]){
        headers = httpHeader
    }
    
    public init(postBody:[String:AnyObject]){
        body = postBody
    }
    public init(queryString:String){
        
        query = queryString
    }
    
    public subscript(queryValues:String) -> String {
        get {
            return query ?? ""
        }
        set {
            query = queryValues
        }
    }
    
}
