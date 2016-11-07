//
//  ModelExtension.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 24/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import Alamofire


open class Model: NSObject , ModelProtocol , JsonRepresentable {
    /**
     cacheDelegate provides a Cache implementation for the requests
     */
    public var cacheDelegate: BackboneCacheDelegate?
    public var concurrencyDelegate: BackboneCacheDelegate?
   
 
    open var url:String?
    
    required override public init() {
    }
    
    /**
        Use subscripts for accessing only String values
     */
    subscript(propertyName: String) -> AnyObject?{
        get {
            guard self.responds(to: NSSelectorFromString("propertyName")) else { return nil }
            return value(forKey: propertyName) as AnyObject?
        }
        set(newValue) {
            setValue(newValue, forKey: propertyName)
        }
    }
    // Mark: 100% Backbone funcs

   open func parse(_ response: JSON) {
        reflexion(json:response, mirror: mirror)
        reflectSuperChildren(response, superMirror: mirror.superclassMirror)
    }


    /**
     Return a shallow copy of the model's attributes for JSON stringification. This can be used for persistence, serialization, or for augmentation before being sent to the server. The name of this method is a bit confusing, as it doesn't actually return a JSON string

     */
    open func toJSON() -> String?
    {
        return JSONOperations().JSONStringifyCommand(self.jsonDict())
    }
    
 
    
    // MARK: -- Reflection for Parsing
    internal func reflectSuperChildren(_ jsonResponse: JSON , superMirror:Mirror?)
    {
        if let m = superMirror {
            reflexion(json: jsonResponse, mirror: m)
            reflectSuperChildren(jsonResponse, superMirror: m.superclassMirror)
        }
    }
    
    
    internal func reflexion(json: JSON , mirror:Mirror) {
        
        for case let (varName? , value ) in mirror.children {

            if responds(to:Selector(varName)) {
                
                if let className = self.className(for: value) ,  !isSwiftBasicType(className: className) {
                    let model = self.objectForType(className:className)
                    if let m = model as? Model {
                        m.parse( json[varName])
                        self[varName] = model as AnyObject?
                    }
                    continue
                }
                
                switch json[varName].type {
                case .array:
                    setValue(json[varName].arrayObject , forKey: varName)
                case .dictionary:
                    setValue(json[varName].dictionaryObject, forKey: varName)
                case .string:
                    setValue(json[varName].stringValue, forKey: varName)
                case .number:
                    setValue( String(json[varName].intValue), forKey: varName)
                case .bool:
                    setValue(json[varName].boolValue, forKey: varName)
                default:
                    break
                }
            }
        }
    }
    
    // MARK: -- Helpers
    private var basicTypes = ["string" , "array" ,"dictionary" , "int" , "bool"]
    internal func className(for value: Any) -> String? {
        
        let subMirror = Mirror(reflecting: value)
        var className = String(describing:subMirror.subjectType)
        guard  let leftArrow = className.range(of: ">") , let optionalLiteral = className.range(of: "Optional<") else { return nil }
        className.removeSubrange(leftArrow)
        className.removeSubrange(optionalLiteral)
        
        return className
    }
    
    
    internal func isSwiftBasicType(className:String) -> Bool {
        return basicTypes.contains { (type) -> Bool in
            return className.lowercased().hasPrefix(type)
        }
    }
    
    internal func objectForType(className: String) -> AnyObject? {
        
        var module:String!
        #if DEBUG
            if Bundle.allBundles.count > 1 {
                module = "BackboneSwiftTests"
            } else {
                guard let bundleIdentifier =  Bundle.main.bundleIdentifier else { return nil }
                module = (bundleIdentifier as NSString).pathExtension.replacingOccurrences(of: "-", with: "_")
            }
           
        #else
            guard let bundleIdentifier =  Bundle.main.bundleIdentifier else { return nil }
             module = (bundleIdentifier as NSString).pathExtension.replacingOccurrences(of: "-", with: "_")
        #endif
        
        
        if let modelSubClass =  NSClassFromString("\(module).\(className)") as? NSObject.Type {
            let modelClass = type(of: Model())
            if modelSubClass.isSubclass(of:modelClass) {
                return modelSubClass.init()
            }
        }
        return nil
    }
   
    // MARK: -- Fetchable Protocol
    // see Model+Fetchable.swift
    
    // MARK: -- Deletable
    // see Model+Deletable.swift
    
    // MARK: -- Savable means  PUT

    // See Model+Savable.swift
    
    // MARK: --  POST
    // See Model+Fetchable.swift
   }

