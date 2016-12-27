
//
//  Info.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 04/11/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

extension Savable where Self : Model {
    
    public func save<Self>(usingOptions options: HttpOptions? = nil) -> Promise<(result:Self, metadata: ResponseMetadata)> {
        
        return Promise {  fulfill, reject in
            save(usingOptions: options, onSuccess: { (response) -> Void in
                fulfill((result: response.result as! Self, metadata: response.metadata))
            }) { (error) -> Void in
                reject (error )
            }
        }
    }
    
    public func save(usingOptions options: HttpOptions? = nil, onSuccess: @escaping (ResponseTuple) -> Void, onError: @escaping (BackboneError) -> Void) {
        guard let feedURL = url  else {
            print("Models must have an URL, fetch cancelled")
            onError(.invalidURL)
            return
        }
        var putOptions = HttpOptions(postBody:self.jsonDict())

        if options?.body != nil {
            putOptions = options!
        } else if options != nil {
            putOptions = options!
            putOptions.body = jsonDict()
        }
        
        processOptions(feedURL, inOptions: putOptions  , complete: { (options, url) in
            self.synch( self, modelURL:url, method: .put, options: options,onSuccess: onSuccess, onError: onError)
        })
    }
}
