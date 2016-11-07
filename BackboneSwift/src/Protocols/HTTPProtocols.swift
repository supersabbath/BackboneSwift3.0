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
        Fetch performs and HTTP GET using a promesify sintaxis
     
                let videoModel = Model()
                videoSut.fetch().then { (response) -> () in
                        // get completed
                }
     
     - Parameters:
            - options: http request options like query paramters, body and heades couldbe handle
     - Return: Promise
     - See: ResponseTuple
     */
    func fetch(usingOptions options:HttpOptions?) -> Promise <ResponseTuple>
    
    /**
     Fetch performs and HTTP GET
     
                model.fetch(onSuccess: { (response) in
                    response.result     // the parsed model is also here
                    response.metadata   // http 202. could be found here
    
                }) { (backboneError) in
                    
                }
     - Parameters:
     - options: http request options like query paramters, body and heades couldbe handle
     - onSucess: Async Clousure for the success case . The response argument will be an ResponseTuple
         - See: ResponseTuple
     - onError: Asyn Closure for error case  (https  5xx , not json responses , unable to parse response)
        - See : BackboneError
     - Return: Promise
     */
    
    func fetch(usingOptions options:HttpOptions? , onSuccess: @escaping (ResponseTuple) ->Void , onError:@escaping (BackboneError)->Void)
    
    
    /**
     This method will internally handle the cache using cacheDelegate property
     */
    func jsonFromCache(askDelegate delegate:BackboneCacheDelegate? ,forID cacheID:String?) -> JSON?
}

extension Fetchable {

    /**
     This method will internally handle the cache using cacheDelegate property
     */
    
    public func jsonFromCache(askDelegate delegate:BackboneCacheDelegate? , forID cacheID:String?) -> JSON? {
        
        guard let delegate = delegate , cacheID != nil else { return nil }
        let cachedResponse = delegate.requestCache.object(forKey: cacheID! as NSString)
         debugPrint("retriving from cache \(cacheID!)")
            debugPrint(cachedResponse.debugDescription)
        let jsonObject = JSON(cachedResponse)
        return jsonObject
    }
}

public protocol Deletable : ConnectivityProtocol  {
    // Performs the DELETE http methdo
    @discardableResult
    func delete(usingOptions options:HttpOptions?) -> Promise < ResponseTuple >
    func delete(usingOptions options:HttpOptions? , onSuccess:@escaping (ResponseTuple) ->Void , onError:@escaping(BackboneError)->Void);
    
}

public protocol Savable : ConnectivityProtocol {
 
    /**
        Save () a model to your server
     
     */
    func save(usingOptions options:HttpOptions?) -> Promise <ResponseTuple>
    func save(usingOptions options:HttpOptions? , onSuccess: @escaping(ResponseTuple) ->Void , onError:@escaping(BackboneError)->Void);
    
}


public protocol Creatable : ConnectivityProtocol{
    
    func create(usingOptions options:HttpOptions?) -> Promise <ResponseTuple>
    func create(usingOptions options:HttpOptions? , onSuccess: @escaping(ResponseTuple) ->Void , onError:@escaping(BackboneError)->Void)
    
}
