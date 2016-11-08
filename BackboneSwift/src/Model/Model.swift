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

                switch json[varName].type {
                case .array:
                  
                    let models  = parseCollectionElement(usingJSON: json[varName].arrayValue, propertyName: varName, andValue: value)
                    switch models.count {
                        case 0:
                            setValue(json[varName].arrayObject , forKey: varName)
                        default:
                            setValue(models,forKey: varName)
                    }
     
                case .dictionary:
                    
                    if let modelInstance = makeModel(forProperty: varName, withValue: value, andJSON: json) {
                        self[varName] = modelInstance as AnyObject?
                    } else{
                        setValue(json[varName].dictionaryObject, forKey: varName)
                    }
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
    
    internal func makeModel(forProperty propertyName:String ,withValue value:Any , andJSON json:JSON) -> AnyObject? {
        
            if let className = className(for: value) ,  !isSwiftBasicType(className: className) {
                let model = self.objectForType(className:className)
                if let m = model as? Model {
                    m.parse( json[propertyName])
                   return m
                }
            }
        return nil
    }
    
    internal func parseCollectionElement(usingJSON  json:[JSON], propertyName varName:String , andValue value:Any ) -> [AnyObject] {
        
        var elementsArray: [AnyObject] = []
        json.forEach { (jsonItem) in
            
            if let classDescriptor = className(for: value) {
                if let model = self.objectForType(className:classDescriptor)  {
                        (model as! Model).parse(jsonItem)
                        elementsArray.append(model)
                }
            }
         
        }
        return elementsArray
    
    }
    
    // MARK: -- Helpers
    private var basicTypes = ["string" , "array" ,"dictionary" , "int" , "bool"]
    internal func className(for value: Any) -> String? {
        
        let subMirror = Mirror(reflecting: value)
        let className = String(describing:subMirror.subjectType)
        let match = className.matchingStrings(regex: "[A-Za-z]*>").first?.first
    
        guard var matchedString = match ,  let greaterThanRange = matchedString.range(of: ">") else { return nil }
        matchedString.removeSubrange(greaterThanRange)
        
        
        return matchedString
    }
    
    
    internal func isSwiftBasicType(className:String) -> Bool {
        return basicTypes.contains { (type) -> Bool in
            return className.lowercased().hasPrefix(type)
        }
    }
    
    internal func objectForType(className: String) -> AnyObject? {
        
        var module:String
        #if BB_TEST_TARGET // Will be only be execute on Backbone's Test Target
            if Bundle.allBundles.count > 1 {
                module = "BackboneSwiftTests"
            } else {
                guard let bundleIdentifier =  Bundle.main.bundleIdentifier else { return nil }
                module = (bundleIdentifier as NSString).pathExtension.replacingOccurrences(of: "-", with: "_")
            }
            
        #else
            guard let bundleIdentifier =  Bundle.main.bundleIdentifier else { return nil }
            module = (bundleIdentifier as NSString).pathExtension
        #endif
            func makeInstance(_ module :String , _ className:String) -> AnyObject? {
            
                guard  let modelSubClass =  NSClassFromString("\(module).\(className)") as? NSObject.Type else {
                    return nil
                }
            
                let modelClass = type(of: Model())
                if modelSubClass.isSubclass(of:modelClass) {
                    return modelSubClass.init()
                } else{
                    return nil
            }
        }
        
        let newInstance = makeInstance(module, className) ?? makeInstance(module.replacingOccurrences(of: "-", with: "_"), className)
        return newInstance
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

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.rangeAt($0).location != NSNotFound
                ? nsString.substring(with: result.rangeAt($0))
                : ""
            }
        }
    }
}

