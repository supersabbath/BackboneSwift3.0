//
//  CollectionTest.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 28/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import XCTest
import BackboneSwift
import SwiftyJSON

@testable import BackboneSwift

class CollectionTest: XCTestCase {
    
    var sut:BaseCollection<VideoCollectionSUT>!
    
    override func setUp() {
        super.setUp()
        let model = VideoCollectionSUT()
        sut = BaseCollection<VideoCollectionSUT>(baseUrl :"")
        sut.push(model)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            if let jsonObject = TestDataSource().jsonVideo {
                self.sut.parse(jsonObject)
            }
        }
    }
    
    func testPush(){
        XCTAssertTrue(sut.models.count == 1, "should  have one and has: \(sut.models.count)")
    }
    
    
    func testFecth() {
 
        if let jsonObject = TestDataSource().jsonVideo {

            sut.parse(jsonObject)
            XCTAssertEqual(sut.models.count , 2)
            let video = sut.pop()
            XCTAssertEqual(sut.models.count , 1)
            XCTAssertEqual(video?.contentType , "video")
            XCTAssertTrue((video?.htmlUrl?.hasPrefix("http://www.rtve.es/alacarta/videos/"))! )
        } else {
            XCTFail()
        }
    }
    
}
