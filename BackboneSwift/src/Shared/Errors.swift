//
//  Errors.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 24/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import UIKit

enum SerializationError: Error {
    // We only support structs
    case structRequired
    // The entity does not exist in the Core Data Model
    case unknownEntity(name: String)
    // The provided type cannot be stored in core data
    case unsupportedSubType(label: String?)
}


public enum BackboneError: Error {
    case invalidURL
    case httpError(description:String)
    case errorWithJSON(parameters: [String:AnyObject])
    case parsingError
    case invalidHTTPMethod
    case failedPOST
    case cancelledRequest
}
