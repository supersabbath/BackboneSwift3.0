////
////  Model+Parser.swift
////  BackboneSwift
////
////  Created by Fernando Canon on 27/10/16.
////  Copyright © 2016 Alphabit. All rights reserved.

import Alamofire
import PromiseKit

extension Creatable where Self:Model {

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
