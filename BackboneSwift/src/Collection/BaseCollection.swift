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

open class BaseCollection<GenericModel: ModelProtocol>  : NSObject , BaseObjectProtocol , Fetchable {
    
   
    open var models = [GenericModel]()
    public var url:String?
    open var delegate:BackboneDelegate?
    
    public init(baseUrl url:String) {
        self.url = url
    }
 

    public func toJSON() -> String? {
        return ""
    }

   
    // MARK: - PUBLIC BACKBONE METHODS 🅿️
    
    /**
    Fetch the default set of models for this collection from the server, setting them on the collection when they arrive. The options hash takes success and error callbacks which will both be passed (collection, response, options) as arguments. When the model data returns from the server, it uses set to (intelligently) merge the fetched models, unless you pass {reset: true}, in which case the collection will be (efficiently) reset. Delegates to Backbone.sync under the covers for custom persistence strategies and returns a jqXHR. The server handler for fetch requests should return a JSON array of models.
    */
    
    public func fetch(_ options: HttpOptions?, onSuccess: @escaping (ResponseTuple) -> Void, onError: @escaping (BackboneError) -> Void) {
        
        guard let feedURL = url  else {
            debugPrint("Collections must have an URL, fetch cancelled")
            onError(.invalidURL)
            return
        }
        
        processOptions(feedURL, inOptions: options) { (httpOptions, processedURL) in
            synch(self, modelURL: processedURL, method: .get, onSuccess: onSuccess, onError: onError)
        }
        
    }
    /**
     Promisify Fetch the default set of models for this collection from the server, setting them on the collection when they arrive. The options hash takes success and error callbacks which will both be passed (collection, response, options) as arguments. When the model data returns from the server, it uses set to (intelligently) merge the fetched models, unless you pass {reset: true}, in which case the collection will be (efficiently) reset. Delegates to Backbone.sync under the covers for custom persistence strategies and returns a jqXHR. The server handler for fetch requests should return a JSON array of models.
     */
   open func fetch(_ options:HttpOptions?=nil) -> Promise <ResponseTuple>  {

        return Promise { fulfill, reject in

            fetch(options, onSuccess: { (response) -> Void in
                fulfill(response)
                }, onError: { (error) -> Void in
                reject(error)
            })
        }
    }

//    
//    // TODO create() POST
//    
//    internal func synch(_ collectionURL:URLConvertible , method:String , options:HttpOptions? = nil, onSuccess: @escaping (CollectionResponse)->Void , onError:@escaping (BackboneError)->Void ){
//        
//        let json =  getJSONFromCache(collectionURL.URLString)
//      
//        guard json == nil else {
//            self.parse(json!)
//            let response = ResponseMetadata(fromCache: true)
//            let result = (self.models,response)
//            onSuccess(result)
//            return
//        }
//
//        Alamofire.request(Alamofire.Method(rawValue: method)!, collectionURL , headers:options?.headers )
//            .validate()
//            .responseJSON { response in
//                
//                switch response.result {
//                case .success:
//                    if let jsonValue = response.result.value {
//                        
//                        self.parse(jsonValue)
//                        self.addResponseToCache(jsonValue, cacheID: collectionURL.URLString)
//                        
//                        if let httpResponse = response.response {
//                   
//                            let result = ResponseMetadata(httpResponse:httpResponse,fromCache: false)
//                            onSuccess((self.models , result))
//                            return
//                        }
//                    }
//                    onError(.httpError(description:"Unable to create Collection models"))
//                    
//                case .failure(let error):
//                    print(error)
//                    onError(.httpError(description: error.description))
//                }
//        }
//
//    
//    }
    
 
//   internal func processResponse(_ response: Response<AnyObject,NSError> , onSuccess: @escaping (ResponseTuple)->Void , onError:(BackboneError)->Void ){
//    
//     //debugPrint(response.response) // URL response
//
//        if let d = self.delegate {
//            
//            switch response.result {
//            case .success:
//            d.concurrentOperationQueue().async(execute: { () -> Void in
//                if let jsonValue = response.result.value {
//                    
//                    self.parse(jsonValue)
//            
//                }
//
//                DispatchQueue.main.async(execute: { () -> Void in
//                    
//                    let result = (models: self.models,ResponseMetadata(fromCache: false ))
//                    onSuccess(result)
//                    
//                })
//                
//            })
//            case .failure(let error):
//                debugPrint(error)
//                onError(.httpError(description: error.description))
//            }
//            
//        } else {
//            
//            switch response.result {
//            case .success:
//                if let jsonValue = response.result.value {
//                    
//                    self.parse(jsonValue)
//                    let result = (models: self.models,ResponseMetadata(fromCache: false ))
//                    onSuccess(result)
//                }
//            case .failure(let error):
//                print(error)
//                onError(.httpError(description: error.description))
//            }
//            
//        }
//    }
//

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
            populateModelsArray(jsonArray)
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
    open  func pop() -> GenericModel? {
        if (models.count > 0) {
            return models.removeLast()
        } else {
            return nil
        }
    }

    // MARK: Collections Cache
    
    fileprivate func addResponseToCache(_ json :AnyObject, cacheID:String) {
        
        if let d = delegate {
            d.requestCache().setObject(json, forKey: cacheID as AnyObject)
        }
    }

    
    fileprivate func getJSONFromCache(_ cacheID:String) -> AnyObject? {
    
        if let d = delegate {
            let json = d.requestCache().object(forKey: cacheID as AnyObject)
            if let j = json {
          
                return j
            }
        }
        return nil
    }
}



//
