//
//  Model+Fetchable.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 25/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit



public protocol Fetchable : ConnectivityProtocol {
    /**
        Fetch performs and HTTP GET
     
                let videoModel = Model()
                videoSut.fetch().then { (response) -> () in
                        // get completed
                }
     
     - Parameters:
            - options: http request options like query paramters, body and heades couldbe handle
     - Return: Promise
     - See: ResponseTuple
     */
    func fetch(_ options:HttpOptions?) -> Promise <ResponseTuple>
    func fetch(_ options:HttpOptions? , onSuccess: @escaping (ResponseTuple) ->Void , onError:@escaping (BackboneError)->Void)
}


extension Fetchable where Self : Model {
    
    public func fetch(_ options: HttpOptions? = nil) -> Promise<ResponseTuple> {
        
        return Promise(resolvers: { (fulfill, reject) in
            
            fetch(options, onSuccess: { (response) in
                fulfill(response)
                }, onError: { (error) in
                    reject(error)
            })
        })
    }
    
    
    public func fetch(_ options:HttpOptions? = nil, onSuccess: @escaping (ResponseTuple) ->Void , onError:@escaping (BackboneError)->Void){
        
        guard let feedURL = url  else {
            debugPrint("Collections must have an URL, fetch cancelled")
            onError(.invalidURL)
            return
        }
        processOptions(feedURL, inOptions: options  , complete: { [weak self] (options, url) in
            self?.synch(self , modelURL: url, method: .get, options: options,onSuccess: onSuccess, onError: onError)
        })
    }
}

public protocol Deletable {
    // Performs the DELETE http methdo
    func delete(_ options:HttpOptions?) -> Promise < ResponseTuple >
    func delete(_ options:HttpOptions? , onSuccess:@escaping (ResponseTuple) ->Void , onError:@escaping(BackboneError)->Void);
    
}

public protocol Savable {
 
    /**
        Save () a model to your server
     
     */
    func save(_ options:HttpOptions?) -> Promise <ResponseTuple>
    func save(_ options:HttpOptions? , onSuccess: @escaping(ResponseTuple) ->Void , onError:@escaping(BackboneError)->Void);
    
}


public protocol Creatable {
    
    func create(_ options:HttpOptions?) -> Promise <ResponseTuple>
    func create(_ options:HttpOptions? , onSuccess: @escaping(ResponseTuple) ->Void , onError:@escaping(BackboneError)->Void)
    
}
