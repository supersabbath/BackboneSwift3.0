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


public protocol Fetchable {
    
    func fetch(_ options:HttpOptions?) -> Promise <ResponseTuple>
    func fetch(_ options:HttpOptions? , onSuccess: @escaping (ResponseTuple) ->Void , onError:@escaping (BackboneError)->Void)
}


public protocol Deletable {
    
    func delete(_ options:HttpOptions?) -> Promise < ResponseTuple >
    func delete(_ options:HttpOptions? , onSuccess: (ResponseTuple) ->Void , onError:(BackboneError)->Void);
    
}

public protocol Savable {
    
    func save(_ options:HttpOptions?) -> Promise <ResponseTuple>
    func save(_ options:HttpOptions? , onSuccess: (ResponseTuple) ->Void , onError:(BackboneError)->Void);
    
}


public protocol Creatable {
    
    func create(_ options:HttpOptions?) -> Promise <ResponseTuple>
    func create(_ options:HttpOptions? , onSuccess: (ResponseTuple) ->Void , onError:(BackboneError)->Void);
    
}
