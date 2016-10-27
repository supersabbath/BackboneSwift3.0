//
//  JSONRepresentable.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 25/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation
import SwiftyJSON


public protocol JsonRepresentable{
    
    func jsonDict() -> [String:AnyObject]
    var properties: [String] { get }
    var mirror:Mirror { get }
}


extension Model {
 
    public func jsonDict() -> [String:AnyObject] {
        var dict = [String: AnyObject]()
        for p in properties {
            if responds(to:Selector(p)) {
                if let obj = value(forKey: p) {
                    switch obj {
                    case is String:
                        dict[p] = obj as! String as AnyObject?
                    case is Int:
                        dict[p] = obj as! Int as AnyObject?
                    case is Double:
                        dict[p] = obj as! Double as AnyObject?
                    case is JsonRepresentable:
                        dict[p] = (obj as! JsonRepresentable).jsonDict() as AnyObject?
                    case is NSArray:
                        var array = [AnyObject]()
                        for ob in (obj as! NSArray) {
                            array.append((ob as! JsonRepresentable).jsonDict() as AnyObject )
                        }
                        dict[p] = array as AnyObject?
                    default:
                        break
                    }
                }
            }
        }
        return dict
    }
    // Computed value that retunrs the Model properties names . Will use reflection (Mirror) to get the values
 
    public var mirror: Mirror {
        return Mirror(reflecting: self)
    }
    
    public var  properties: [String]  {
        return mirror.children.flatMap { $0.label }
    }
}
