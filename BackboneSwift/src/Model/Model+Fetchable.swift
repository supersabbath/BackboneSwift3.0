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
import SwiftyJSON

extension Fetchable where Self : Model {
<<<<<<< HEAD

    
    public func fetch(usingOptions options: HttpOptions? = nil) -> Promise<ResponseTuple> {
        return Promise(resolvers: { (fulfill, reject) in
=======
    
    public func fetch<Self>(usingOptions options: HttpOptions? = nil) -> Promise<(result:Self,metadata: ResponseMetadata)> {
        return Promise<(result:Self,metadata: ResponseMetadata)>(resolvers: { (fulfill, reject) in
>>>>>>> 13a663c632b50b49ab6523d14fccaa8086e313f0
            fetch(usingOptions:options, onSuccess: { (response) in
                fulfill((result: response.result as! Self, metadata: response.metadata))
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
        processOptions(feedURL, inOptions: options) { [weak self] (options, processedURL) in
            
            guard self != nil else { return }
    
            let json = self!.jsonFromCache(askDelegate: self!.cacheDelegate , forID:processedURL.url?.absoluteString)
            if json?.isEmpty == false {
                self!.parse(json!)
                let metadata = ResponseMetadata(fromCache: true)
                onSuccess((result:self! , metadata:metadata))
                
            } else {
                self!.synch(self , modelURL: processedURL, method: .get, options: options,onSuccess: onSuccess, onError: onError)
            }
        }
    }
}

