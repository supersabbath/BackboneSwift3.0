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

    public func parse(_ response: JSON) {
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
        
        if let modelSubClass =  NSClassFromString("BackboneSwift."+className) as? NSObject.Type {
            let modelClass = type(of: Model())
            if modelSubClass.isSubclass(of:modelClass) {
                return modelSubClass.init()
            }
        }
        return nil
    }
   
    // MARK: -- Fetchable Protocol

    
    // MARK: -- Deletable
    public func delete(_ options: HttpOptions? = nil) -> Promise<ResponseTuple> {
        return Promise { (fulfill, reject) in
            delete(options, onSuccess: { (result) -> Void in
                fulfill(result)
                }, onError: { (error) in
                reject(error)
            })
        }
    }
    
    public func delete(_ options: HttpOptions? = nil , onSuccess:@escaping (ResponseTuple) -> Void, onError:@escaping (BackboneError) -> Void) {
        guard let feedURL = url  else {
            print("Models must have an URL, DELETE cancelled")
            onError(.invalidURL)
            return
        }
        processOptions(feedURL, inOptions: options  , complete: { (options, url) in
            self.synch(self, modelURL: url, method: .delete , options: options,onSuccess: onSuccess, onError: onError)
        })
    }
     // MARK: -- Savable means  PUT
    public func save(_ options: HttpOptions? = nil) -> Promise<ResponseTuple> {
    
        return Promise {  fulfill, reject in
                save(options, onSuccess: { (result) -> Void in
                    fulfill(result)
                }) { (error) -> Void in
                    reject (error )
                }
        }
    }
    
    public func save(_ options: HttpOptions? = nil, onSuccess: @escaping (ResponseTuple) -> Void, onError: @escaping (BackboneError) -> Void) {
        guard let feedURL = url  else {
            print("Models must have an URL, fetch cancelled")
            onError(.invalidURL)
            return
        }
        var putOptions = options
        if options != nil {
             putOptions?.body = jsonDict()
        }else {
            putOptions = HttpOptions(postBody:jsonDict())
        }
        processOptions(feedURL, inOptions: putOptions  , complete: { (options, url) in
            self.synch( self, modelURL:url, method: .put, options: options,onSuccess: onSuccess, onError: onError)
        })
    }
    // MARK: --  POST
    public func create(_ options:HttpOptions? = nil) -> Promise <ResponseTuple> {
        return Promise {  fulfill, reject in
            create(options, onSuccess: { (result) -> Void in
                fulfill(result)
                }, onError: { (error) -> Void in
                reject (error )
            })
        }
    }
    
    public func create(_ options:HttpOptions?  = nil , onSuccess: @escaping(ResponseTuple) ->Void , onError:@escaping(BackboneError)->Void) {
        guard let feedURL = url  else {
            print("Models must have an URL, fetch cancelled")
            onError(.invalidURL)
            return
        }
        var postOptions = options
        if options != nil {
            postOptions?.body = jsonDict()
        }else {
            postOptions = HttpOptions(postBody:jsonDict())
        }
        processOptions(feedURL, inOptions: postOptions  , complete: { (options, url) in
            self.synch(self , modelURL: url, method: .post, options: options,onSuccess: onSuccess, onError: onError)
        })
    }
}

