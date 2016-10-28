//
//  ModelProtocol.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 24/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import Alamofire



//public typealias CollectionResponse = (models:[GenericModel], response:ResponseMetadata)

public protocol ModelProtocol : BaseObjectProtocol, Fetchable, Deletable , Savable , Creatable
{
    init() // ??
}




public protocol  BaseObjectProtocol {

    /**
     - *url*  the relative URL where the model's resource would be located on the server. If your models are located somewhere else, override this method with the correct logic. Generates URLs of the form: "[collection.url]/[id]" by default, but you may override by specifying an explicit urlRoot if the model's collection shouldn't be taken into account.
     */
    var url:String? { get set }
    // Functions
    /**
     parse() handles the plain Swift JSON object parsing.
     */
    func parse(_ response: JSON)
    func toJSON() -> String?
}

