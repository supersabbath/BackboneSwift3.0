//
//  Collection.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 21/01/16.
//  Copyright © 2016 alphabit. All rights reserved.
//


import UIKit
import SwiftyJSON
import Alamofire
import PromiseKit
//
//
//
//public enum RESTMethod {
//    case  get,post,put,delete
//}
//

open class BaseCollection<GenericModel: ModelProtocol>  : NSObject , BaseObjectProtocol {
    
   
    open var models = [GenericModel]()
    public var url:String?
    public var concurrencyDelegate: BackboneCacheDelegate?
    public var cacheDelegate: BackboneCacheDelegate?
    
    public init(baseUrl url:String) {
        self.url = url
    }
 

    public func toJSON() -> String? {
        return ""
    }


    /**
     
     parse is called by Backbone whenever a collection's models are returned by the server, in fetch. The function is passed the raw response object, and should return the array of model attributes to be added to the collection. The default implementation is a no-op, simply passing through the JSON response. Override this if you need to work with a preexisting API, or better namespace your responses.
     */
    
    open func parse(_ response: JSON) {
        
        switch response.type {
            case .array:
                populateModelsArray(response.arrayValue)
            case .dictionary:
                let jsonArray =  response.dictionaryValue.map{ (key , jsonValue) -> JSON in
                    return jsonValue
                }
                if let titles = response["titles"].array {
                      populateModelsArray(jsonArray)
                }
          
            default:
                print("Collections Parse should received a Sequece ")
            }
    }

    
    internal func populateModelsArray( _ unParsedArray:[JSON]) {
        unParsedArray.forEach{ (item) -> () in
            let model = GenericModel.init()
            model.parse(item)
            push(model)
        }
    }

    /**
     Add a model at the end of a collection. Takes the same options as add.
    */
    open  func push(_ item: GenericModel) {
        models.append(item)
    }
    
    
    /**
     Remove and return the last model from a collection. TODO: [Takes the same options as remove.]
    */
    @discardableResult open  func pop() -> GenericModel? {
        if (models.count > 0) {
            return models.removeLast()
        } else {
            return nil
        }
    }

   // MARK: Collections Cache
        // See:  ConnectivityProtocol and Fetchable implementations
    
}
