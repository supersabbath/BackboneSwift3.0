//
//  Mocks.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 07/11/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation

@testable import BackboneSwift

class MockCache : BackboneCacheDelegate {
    var requestCache: NSCache<NSString, AnyObject> = NSCache()
}
        
