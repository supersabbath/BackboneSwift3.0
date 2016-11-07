//
//  ViewController.swift
//  Backbone-IOS-Demo
//
//  Created by Fernando Canon on 07/11/16.
//  Copyright © 2016 StarzPlay. All rights reserved.
//

import UIKit
import BackboneSwift
import SwiftyJSON
import PromiseKit

class ViewController: UIViewController {
    
    let video = Video()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        video.url =  "http://www.rtve.es/api/videos.json?size=1"
        video.fetch().then { (respose) -> Void in
            print("Video uri: \(self.video.uri)")
            print("Video pubState: \(self.video.pubState?.code)")
        }.catch { (error) in
                print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class PubState:Model {
    var code:String?
}


class Video: Model {
    
    var uri:String?
    var language:String?
    var pubState:PubState?
    
     override func parse(_ response: JSON) {
        if let videdDic = response["page"]["items"].arrayValue.first {
            super.parse(videdDic)
        }
    }
   
    func fetch(usingOptions options: HttpOptions?, onSuccess: @escaping (ResponseTuple) -> Void, onError: @escaping (BackboneError) -> Void) {
        print("test")
    }
}

class VideoCollection: BaseCollection<Model> {
    
}
