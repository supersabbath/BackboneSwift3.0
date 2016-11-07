//
//  ModelTests.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 25/10/16.
//  Copyright © 2016 Alphabit. All rights reserved.
//

import XCTest

@testable import BackboneSwift
import SwiftyJSON

class ModelTests: XCTestCase {
    
    var sut:JayCDumpClass!
    
    override func setUp() {
        super.setUp()
        sut = JayCDumpClass()
        sut.url = "www.google.com"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        sut = nil
    }
 
    
    func testParsePerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            self.sut.parse(JSON(["dd":"hola", "juancarlos":"nothing","hoasd":"adfasdf","h2":"adfasdf"]))
        }
    }
    
    func testParse() {
        sut.parse(JSON(TestDataSource().jsonBasicEntity))
        XCTAssertEqual(sut.dummyString, "dummyValue")
        XCTAssertEqual(sut.dummyJuanCarlos, "jayc")
        XCTAssertTrue(sut.dummyBoolean)
        
    }
    
    func testModelFecth()
    {
        let asyncExpectation = expectation(description: "modelFetchAsynchTest")
        
        let videoSut = VideoSUT();
        videoSut.url  = "http://www.rtve.es/api/videos.json?size=1"
        videoSut.fetch(HttpOptions()).then { (response) -> () in
            asyncExpectation.fulfill()
            XCTAssertTrue((videoSut.uri!.hasPrefix("http://www.rtve.es/api/videos")),"should have the same prefix"  )
        }.catch { (error) in
            XCTFail()
        }
        self.waitForExpectations(timeout: 60, handler:{ (error) in
            print("time out")
        });
    }
    
    func testParseWithInnerModel(){
        
        let testSut = DummyClassWithSubclass()
        let testData = TestDataSource().jsonComplexEntity
        let json = JSON(testData)
        testSut.parse(json)
        XCTAssertEqual(testSut.name, "john")
        XCTAssertEqual(testSut.intValue, "23")
        XCTAssertNotNil(testSut.backboneModel)
        XCTAssertEqual(testSut.backboneModel?.dummyJuanCarlos, "jayc")
        XCTAssertEqual(testSut.backboneModel?.dummyString, "dummyValue")
        XCTAssertEqual(testSut.array?.first! as! String, "1")
        let dic = testSut.dictionary as! [String:String]
        XCTAssertEqual(dic["setting"],"value")
    }
    
    
    func testTwoSubClassingLeves(){
        
        let testSUT = TwoLevelsOfSubclass()
        let dataSource = TestDataSource().jsonForTwoSubClassingLeves()
        testSUT.parse(dataSource)
        XCTAssertEqual(testSUT.customValue, "value")
        XCTAssertEqual(testSUT.name, "john")
        XCTAssertEqual(testSUT.intValue, "23")
        XCTAssertNotNil(testSUT.backboneModel)
        XCTAssertEqual(testSUT.backboneModel?.dummyJuanCarlos, "jayc")
        XCTAssertEqual(testSUT.backboneModel?.dummyString, "dummyValue")
        XCTAssertEqual(testSUT.array?.first! as! String, "1")
        let dic = testSUT.dictionary as! [String:String]
        XCTAssertEqual(dic["setting"],"value")
    }
    
    func testParsePerformanceComplex() {
    
        let testSub = DummyClassWithSubclass()
        let testData = TestDataSource().jsonComplexEntity
    
        self.measure {
            let json = JSON(testData)
            testSub.parse(json)
        }
    }
    
    
    func testSynchReturnsErrorWithJSONIfResponseReturnsJSON() {
        
        //url that returns error and JSON
        let url = "http://link.theplatform.eu/s"
        sut.url = url
        let asyncExpectation = expectation(description: "withJSONIfResponseReturnsJSON")
    
        sut.fetch().then { (response) -> Void in
           XCTFail()
        }.catch { (error) in
            switch error as! BackboneError {
            case .errorWithJSON(let parameters):
                XCTAssertTrue(parameters.count > 0)
                asyncExpectation.fulfill()
                break
            default:
                XCTFail()
                break
            }
        }
        self.waitForExpectations(timeout: 10, handler:{ (error) in
            print("time out")
        });
    }
   


    func testSynchReturnsOKIfResponseNotReturningJSONAndStatusBetween200And399() {
        let url = "http://www.google.es" // Expected status 200
        sut.url = url
        let asyncExpectation = expectation(description: "ResponseNotReturningJSON")
       
        sut.fetch(onSuccess: { (response) in
            XCTAssertNil(self.sut.dummyString) // should be nil
             asyncExpectation.fulfill()
        
        }) { (backboneError) in
                switch backboneError {
                case .parsingError:
                    XCTAssertNotNil(backboneError)
                     asyncExpectation.fulfill()
                    break
                default:
                    XCTFail()
                }
        }
        self.waitForExpectations(timeout: 10, handler:{ (error) in
            print("time out")
        });
    }
    
    func testSynchReturnsHTTPErrorIfResponseNotReturningJSONAndStatusMoreThan400() {
        let url = "http://httpstat.us/404" // Expected status 200
        sut.url = url
        let asyncExpectation = expectation(description: "ResponseNotReturningJSON")
        sut.fetch(onSuccess: { (response) in
             XCTFail()
        }) { (backboneError) in
            
            switch backboneError {
            case .httpError(let description):
                XCTAssertEqual(description , "404")
                asyncExpectation.fulfill()
                break
            default:
                XCTFail()
            }
        }
        self.waitForExpectations(timeout: 10, handler:{ (error) in
            print("time out")
        });
    }
    
    func testSyncShouldReturnHTTPErrorFor3xx () {
        
        let url = "http://httpstat.us/304"
        sut.url = url
        let asyncExpectation = expectation(description: "testSyncShouldReturnHTTPErrorFor3xx")
        
        sut.fetch(onSuccess: { (result) in
            XCTAssertNotNil(result.result)
            XCTAssertEqual( result.metadata.httpStatus , 304)
            asyncExpectation.fulfill()
        }){ (error) -> Void in
            XCTFail()
        }
        self.waitForExpectations(timeout: 10, handler:{ (error) in
            print("time out")
        });
    }
    
    
    // MARK:  Delete
    
    /**
     Test naming convention for StarzPlay
     */
    func  testDeleteShouldSuccess() {
        
        let asyncExpectation = expectation(description: "testDeleteShouldSuccess")
        //given
        sut.url = "http://httpbin.org/delete"
        //when
        sut.delete().then { (result) -> Void in
            //then
            XCTAssertTrue(result.metadata.httpStatus == 200)
            asyncExpectation.fulfill()
        }.catch { (err) in
                XCTFail()
                asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 100, handler:{ (error) in
            print("test time out")
        });
    }
    // MARK: PUT
    func  testPUTShouldSuccess() {
        
        let asyncExpectation = expectation(description: "testPUTShouldSuccess")
        //given
        sut.url = "http://httpbin.org/put"
        sut.dummyJuanCarlos = "jayC"
        sut.dummyBoolean = true
        //when
        sut.save().then { (result) -> Void in
            //then
            XCTAssertTrue(result.metadata.httpStatus == 200)
           
            asyncExpectation.fulfill()
            }.catch { (err) in
                XCTFail()
                asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 100, handler:{ (error) in
            print("test time out")
        });
    }
      // MARK: POST 
    func  testPOSTShouldSuccess() {
        
        let asyncExpectation = expectation(description: "testPOSTShouldSuccess")
        //given
        sut.url = "http://httpbin.org/post"
        sut.dummyJuanCarlos = "jayC"
        sut.dummyBoolean = true
        //when
        sut.create().then { (resultTuple) -> Void in
            //then
            XCTAssertTrue(resultTuple.metadata.httpStatus == 200)
            asyncExpectation.fulfill()
            }.catch { (err) in
                XCTFail()
                asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 100, handler:{ (error) in
            print("test time out")
        });
    }
    
}
