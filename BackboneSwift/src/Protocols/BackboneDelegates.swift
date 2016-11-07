//
//  BackboneDelegates.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 28/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation


public protocol BackboneConcurrencyDelegate {
    /**
        concurrentOperationQueue property will be used to perform long running task in a background
     */
    var concurrentOperationQueue:DispatchQueue { get set }
}


public protocol BackboneCacheDelegate {
    /**
        requestCache is NSCache implementation that will handle an standart cache for the GET resquests
     */
    var requestCache: NSCache<NSString, AnyObject> { get set }
}

