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
import PromiseKit

@testable import BackboneSwift

class CollectionTest: XCTestCase {
    
    var collectionSUT:BaseCollection<VideoCollectionSUT>!
    
    override func setUp() {
        super.setUp()
        let model = VideoCollectionSUT()
        collectionSUT = BaseCollection<VideoCollectionSUT>(baseUrl :"")
        collectionSUT.push(model)
    }
    
    override func tearDown() {
        collectionSUT = nil
        super.tearDown()
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            if let jsonObject = TestDataSource().jsonVideo {
                self.collectionSUT.parse(jsonObject)
            }
        }
    }
    
    func testPush(){
        XCTAssertTrue(collectionSUT.models.count == 1, "should  have one and has: \(collectionSUT.models.count)")
    }
    
    func testPop() {
        _  = collectionSUT?.pop()
        _ = collectionSUT?.pop()
        XCTAssertTrue(collectionSUT!.models.count == 0, "should  have one and has: \(collectionSUT?.models.count)")
    }
    
    func testParse() {
 
        if let jsonObject = TestDataSource().jsonVideo {

            collectionSUT.parse(jsonObject)
            XCTAssertEqual(collectionSUT.models.count , 2)
            let video = collectionSUT.pop()
            XCTAssertEqual(collectionSUT.models.count , 1)
            XCTAssertEqual(video?.contentType , "video")
            XCTAssertTrue((video?.htmlUrl?.hasPrefix("http://www.rtve.es/alacarta/videos/"))! )
        } else {
            XCTFail()
        }
    }
    
    
    func testGithubAPI_Promisefy (){
    
        let asyncExpectation = expectation(description: "testGithubAPI_Promisefy")
        let sutCollection = BaseCollection <ProjectSUT>(baseUrl:  "https://api.github.com/users/google/repos?page=1&per_page=7")
        
        sutCollection.fetch().then { (result:BaseCollection <ProjectSUT>, data) -> Void in
            XCTAssertTrue((sutCollection.pop()?.full_name!.contains("google")) == true)
            XCTAssertTrue(sutCollection.models.count !=  7, "should have the same number")
            asyncExpectation.fulfill()
        }.catch { (error) in
            XCTFail()
        }
       
        
        self.waitForExpectations(timeout: 10, handler:{ (error) in
            print("time out")
        });
    }

    
    func testGithubAPI (){
        
        let asyncExpectation = expectation(description: "testGithubAPI")
        let sutCollection = BaseCollection <ProjectSUT>(baseUrl: "https://api.github.com/users/google/repos")
        let options = HttpOptions(queryString: "page=1&per_page=7")
        sutCollection.fetch(usingOptions: options, onSuccess: { (objs) -> Void in
            XCTAssertTrue((sutCollection.pop()?.full_name!.contains("google")) == true)
            XCTAssertTrue(sutCollection.models.count !=  7, "should have the same number")
            asyncExpectation.fulfill()
            }, onError:{ (error) -> Void in
                XCTFail()
        })
        self.waitForExpectations(timeout: 10, handler:{ (error) in
            print("time out")
        });
    }
    
    func testCacheRequestShouldSucced () {
        let cacheMock = MockCache()
        let asyncExpectation = expectation(description: "testCacheRequest")
        let sutCollection = BaseCollection <ProjectSUT>(baseUrl: "https://api.github.com/users/google/repos")
        sutCollection.cacheDelegate = cacheMock
        var options = HttpOptions(queryString: "page=1&per_page=3")
        options.useCache = true
        var options2 = HttpOptions(queryString: "page=1&per_page=3")
        options2.useCache = true
        sutCollection.fetch(usingOptions:options).then { (response:BaseCollection <ProjectSUT>, metadata) -> Promise<ResponseTuple> in

            return sutCollection.fetch(usingOptions:options2)
        }.then { (response) -> Void in
            
            XCTAssertTrue(response.metadata.isCacheResult)
            XCTAssertTrue((sutCollection.pop()?.full_name!.contains("google")) == true)
            XCTAssertTrue(sutCollection.models.count !=  3, "should have the same number")
            asyncExpectation.fulfill()
        }.catch { error in
           XCTFail()
        }
        
     
        self.waitForExpectations(timeout: 60, handler:{ (error) in
            print("time out")
        });
    }
    
    
    func testDictionaryCollection(){
        
        let asyncExpectation = expectation(description: "testDictionaryCollection")
        let url = "https://peg-dev-public-api.eu.cloudhub.io/api/v0.2/mediaCatalog/titles/25493544051"
        let sut = SeriesCollection(baseUrl: url)
        sut.fetch().then { (result:SeriesCollection, metadata) -> Void in
            XCTAssertTrue(result.models.first?.title == "Weeds")
            asyncExpectation.fulfill()
        }.catch { (error) in
            XCTFail()
        }
        waitForExpectations(timeout: 20) { (error) in print("Time out")}
    }
 
}
