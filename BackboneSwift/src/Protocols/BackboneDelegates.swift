//
//  BackboneDelegates.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 28/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation


public protocol BackboneConcurrencyDelegate {
    func concurrentOperationQueue() -> DispatchQueue
}


public protocol BackboneCacheDelegate {
    func requestCache() -> NSCache<AnyObject, AnyObject>
}

public typealias BackboneDelegate = BackboneCacheDelegate & BackboneConcurrencyDelegate
