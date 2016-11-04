//
//  Collection+Extensions.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 28/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit


extension BaseCollection : Fetchable {

    /**
     Fetch the default set of models for this collection from the server, setting them on the collection when they arrive. The options hash takes success and error callbacks which will both be passed (collection, response, options) as arguments. When the model data returns from the server, it uses set to (intelligently) merge the fetched models, unless you pass {reset: true}, in which case the collection will be (efficiently) reset. Delegates to Backbone.sync under the covers for custom persistence strategies and returns a jqXHR. The server handler for fetch requests should return a JSON array of models.
     */
    
    public func fetch(_ options: HttpOptions?, onSuccess: @escaping (ResponseTuple) -> Void, onError: @escaping (BackboneError) -> Void) {
        
        guard let feedURL = url  else {
            debugPrint("Collections must have an URL, fetch cancelled")
            onError(.invalidURL)
            return
        }
        
        processOptions(feedURL, inOptions: options) { (httpOptions, processedURL) in
            synch(self, modelURL: processedURL, method: .get, onSuccess: onSuccess, onError: onError)
        }
        
    }
    /**
     Promisify Fetch the default set of models for this collection from the server, setting them on the collection when they arrive. The options hash takes success and error callbacks which will both be passed (collection, response, options) as arguments. When the model data returns from the server, it uses set to (intelligently) merge the fetched models, unless you pass {reset: true}, in which case the collection will be (efficiently) reset. Delegates to Backbone.sync under the covers for custom persistence strategies and returns a jqXHR. The server handler for fetch requests should return a JSON array of models.
     */
    @discardableResult
    public func fetch(_ options:HttpOptions?=nil) -> Promise <ResponseTuple>  {
        
        return Promise { fulfill, reject in
            
            fetch(options, onSuccess: { (response) -> Void in
                fulfill(response)
                }, onError: { (error) -> Void in
                    reject(error)
            })
        }
    }
}
