//
//  Model+Deletable.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 04/11/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit


extension Deletable where Self : Model {

    public func delete(usingOptions options: HttpOptions? = nil) -> Promise<ResponseTuple> {
        return Promise { (fulfill, reject) in
            delete(usingOptions: options, onSuccess: { (result) -> Void in
                fulfill(result)
                }, onError: { (error) in
                    reject(error)
            })
        }
    }
    
    public func delete(usingOptions options: HttpOptions? = nil , onSuccess:@escaping (ResponseTuple) -> Void, onError:@escaping (BackboneError) -> Void) {
        guard let feedURL = url  else {
            print("Models must have an URL, DELETE cancelled")
            onError(.invalidURL)
            return
        }
        processOptions(feedURL, inOptions: options  , complete: { (options, url) in
            self.synch(self, modelURL: url, method: .delete , options: options,onSuccess: onSuccess, onError: onError)
        })
    }
}
