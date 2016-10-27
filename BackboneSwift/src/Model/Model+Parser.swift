////
////  Model+Parser.swift
////  BackboneSwift
////
////  Created by Fernando Canon on 27/10/16.
////  Copyright © 2016 Alphabit. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
//import UIKit
//
//public protocol ParsingProtocol : class  {
//
//    func parseExtension(_ jsonResponse: JSON , mirror:Mirror)
//}
//
//
//private var basicTypes = ["string" , "array" ,"dictionary" , "int" , "bool"]
//
//
//extension NSObject : ParsingProtocol {
//
//    /**
//     parse is called whenever a model's data is returned by the server, in fetch, and save. The function is passed the raw response object, and should return the attributes hash to be set on the model. The default implementation is a no-op, simply passing through the JSON response. Override this if you need to work with a preexisting API, or better namespace your responses.
//     */
//    public func parseExtension(_ jsonResponse: JSON , mirror:Mirror)  {
//        reflexion(json:jsonResponse, mirror: mirror)
//        reflectSuperChildren(jsonResponse, superMirror: mirror.superclassMirror)
//    }
//
//    // MARK: -- Reflection
//    internal func reflectSuperChildren(_ jsonResponse: JSON , superMirror:Mirror?)
//    {
//        if let m = superMirror {
//            reflexion(json: jsonResponse, mirror: m)
//            reflectSuperChildren(jsonResponse, superMirror: m.superclassMirror)
//        }
//    }
//    
//
//    internal func reflexion(json: JSON , mirror:Mirror) {
//        
//        
//        for case let (varName? , value ) in mirror.children {
//            
//            if responds(to:Selector(varName)) {
//                
//                if let className = self.className(for: value) ,  !isSwiftBasicType(className: className) {
//                    let model = self.objectForType(className:className)
//                    if let m = model as? Model {
//                        m.parseExtension(json[varName] , mirror: m.mirror)
////                        self[varName] = model as AnyObject?
//                        setValue(m , forKey: varName)
//                    }
//                    continue
//                }
//                
//                switch json[varName].type {
//                case .array:
//                    setValue(json[varName].arrayObject , forKey: varName)
//                case .dictionary:
//                    setValue(json[varName].dictionaryObject, forKey: varName)
//                case .string:
//                    setValue(json[varName].stringValue, forKey: varName)
//                case .number:
//                    setValue( String(json[varName].intValue), forKey: varName)
//                case .bool:
//                    setValue(json[varName].boolValue, forKey: varName)
//                default:
//                    break
//                }
//            }
//        }
//    }
//    
//    // MARK: -- Helpers
//    internal func className(for value: Any) -> String? {
//        
//        let subMirror = Mirror(reflecting: value)
//        var className = String(describing:subMirror.subjectType)
//        guard  let leftArrow = className.range(of: ">") , let optionalLiteral = className.range(of: "Optional<") else { return nil }
//        className.removeSubrange(leftArrow)
//        className.removeSubrange(optionalLiteral)
//        
//        return className
//    }
//    
//    
//    internal func isSwiftBasicType(className:String) -> Bool {
//        return basicTypes.contains { (type) -> Bool in
//            return className.lowercased().hasPrefix(type)
//        }
//    }
//    
//    internal func objectForType(className: String) -> AnyObject? {
//        
//        if let modelSubClass =  NSClassFromString("BackboneSwift."+className) as? NSObject.Type {
//            let modelClass = type(of: Model())
//            if modelSubClass.isSubclass(of:modelClass) {
//                return modelSubClass.init()
//            }
//        }
//        return nil
//    }
//}
