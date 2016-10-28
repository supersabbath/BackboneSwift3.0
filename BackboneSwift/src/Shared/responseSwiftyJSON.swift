//
//  responseSwiftyJSON.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 25/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON



extension DataRequest {
 
    /**
     Adds a handler to be called once the request has finished.
     -parameters:
        -parameter: queue The queue on which the completion handler is dispatched.
        -parameter: options The JSON serialization reading options. `.AllowFragments` by default.
        -parameter: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
     
     -returns: The request.
     */
    
    @discardableResult
    public func responseSwiftyJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any> , JSON?) -> Void)
        -> Self
    {
       return  response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer(options: options) , completionHandler: { (dataSerialization) in
        
            let callbackQueue = queue ?? DispatchQueue.main
            DispatchQueue.global(qos: .default).async {

                switch dataSerialization.result {
                case .failure(let error):
                    debugPrint("No Json \(error). returning response")
                    callbackQueue.async {
                        completionHandler(dataSerialization, nil)
                    }
           
                case .success(let value) :
                    let responseJSON = JSON(value)
                  
                    callbackQueue.async {
                        completionHandler(dataSerialization, responseJSON)
                    }
                }
            }
       })
    }
    
}
