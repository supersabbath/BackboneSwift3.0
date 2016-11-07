//
//  Model+Fetchable.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 28/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit


extension Fetchable where Self : Model {
    
    public func fetch(usingOptions options: HttpOptions? = nil) -> Promise<ResponseTuple> {
        return Promise(resolvers: { (fulfill, reject) in
            
            fetch(usingOptions:options, onSuccess: { (response) in
                fulfill(response)
                }, onError: { (error) in
                    reject(error)
            })
        })
    }
    
    
    
    public func fetch(usingOptions options:HttpOptions? = nil, onSuccess: @escaping (ResponseTuple) ->Void , onError:@escaping (BackboneError)->Void){
        
        guard let feedURL = url  else {
            debugPrint("Collections must have an URL, fetch cancelled")
            onError(.invalidURL)
            return
        }
        processOptions(feedURL, inOptions: options  , complete: { [weak self] (options, processedURL) in
            self?.synch(self , modelURL: processedURL, method: .get, options: options,onSuccess: onSuccess, onError: onError)
            })
    }
}
