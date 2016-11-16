////
////  Model+Parser.swift
////  BackboneSwift
////
////  Created by Fernando Canon on 27/10/16.
////  Copyright © 2016 Alphabit. All rights reserved.

import Alamofire
import PromiseKit

extension Creatable where Self:Model {
    
    public func create<Self>(usingOptions options:HttpOptions? = nil ) -> Promise <(result:Self, metadata: ResponseMetadata)> {
        return Promise {  fulfill, reject in
            create(usingOptions: options, onSuccess: { (response) -> Void in
                    fulfill((result: response.result as! Self, metadata: response.metadata))
            }, onError: { (error) -> Void in
                    reject (error)
            })
        }
    }
    
    public func create(usingOptions options:HttpOptions?  = nil , onSuccess: @escaping(ResponseTuple) ->Void , onError:@escaping(BackboneError)->Void) {
        guard let feedURL = url  else {
            print("Models must have an URL, fetch cancelled")
            onError(.invalidURL)
            return
        }
        
        var postOptions = options
        if options != nil {
            if postOptions?.body == nil {
                postOptions?.body = jsonDict()
            }
        } else {
            postOptions = HttpOptions(postBody:jsonDict())
        }
        processOptions(feedURL, inOptions: postOptions  , complete: { [weak self] (options, url) in
            guard self != nil else { onError(BackboneError.cancelledRequest);  return }
            self!.synch(self! , modelURL: url, method: .post, options: options,onSuccess: onSuccess, onError: onError)
        })
    }

}
