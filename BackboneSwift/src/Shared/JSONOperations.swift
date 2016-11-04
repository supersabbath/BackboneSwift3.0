//
//  JSONOperations.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 24/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import UIKit

public struct JSONOperations {
    
   static public func JSONFromBytes(_ bytes: Data ) -> AnyObject?
    {
        let options = JSONSerialization.ReadingOptions(rawValue: 0)
        do {
            let data =  try JSONSerialization.jsonObject(with: bytes, options: options)
            return data as AnyObject?
        }catch {
            print("error JSONStringify")
        }
        return nil
    }
    
    
    public func JSONStringifyCommand( _ messageDictionary : Dictionary <String, AnyObject>) -> String?
    {
        let options = JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(messageDictionary) {
            do {
                let data =  try JSONSerialization.data(withJSONObject: messageDictionary, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                print("error JSONStringify")
            }
        }
        return nil
    }
    
    
    func JSONSerialize( _ jsonSerializableObject : AnyObject ) -> Data?
    {
        let options = JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(jsonSerializableObject) {
            do {
                let data =  try JSONSerialization.data(withJSONObject: jsonSerializableObject, options: options)
                return data
            }catch {
                print("error JSONStringify")
            }
        }
        return nil
    }
}
