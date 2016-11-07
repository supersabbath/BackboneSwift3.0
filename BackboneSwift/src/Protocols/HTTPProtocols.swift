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
    @discardableResult
    func fetch(usingOptions options:HttpOptions?) -> Promise <ResponseTuple>
    func fetch(usingOptions options:HttpOptions? , onSuccess: @escaping (ResponseTuple) ->Void , onError:@escaping (BackboneError)->Void)
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
