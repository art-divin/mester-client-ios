//
//  TestTests.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 23/07/15.
//  Copyright © 2015 Ruslan Alikhamov. All rights reserved.
//

import XCTest

@testable import Mester

class TestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func loadData(filename: String!, ext: String!) -> NSData? {
		let bundle = NSBundle(forClass: self.dynamicType)
		XCTAssertNotNil(bundle, "invalid bundle provided")
		let url = bundle.URLForResource(filename, withExtension: ext)
		XCTAssertNotNil(url, "invalid url provided")
		let data = NSData(contentsOfURL: url!)
		XCTAssertNotNil(data, "could not load json file")
		return data
	}
	
	func testDeserializeSuccess() {
		let data = loadData("test", ext: "success")
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
			let dic = json as! Dictionary<String, AnyObject>
			let test = Test()
			test.deserialize(dic)
			XCTAssertNotNil(test.identifier, "invalid deserialization result: identifier")
			XCTAssertNotNil(test.creationDate, "invalid deserialization result: creationDate")
			XCTAssertNotNil(test.startDate, "invalid deserialization result: startDate")
			XCTAssertNotNil(test.endDate, "invalid deserialization result: endDate")
			XCTAssertNotNil(test.caseTests, "invalid deserialization result: caseTests")
			XCTAssertNotNil(test.status.rawValue, "invalid deserialization result: status")
		} catch let error as NSError {
			if let data = data {
				XCTAssertNil(error, "error while parsing json file: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
			}
		}
	}
	
	func testDeserializeFailure() {
		let data = loadData("test", ext: "failure")
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
			let dic = json as! Dictionary<String, AnyObject>
			let test = Test()
			test.deserialize(dic)
			XCTAssertNil(test.identifier, "invalid deserialization result: identifier")
			XCTAssertNil(test.startDate, "invalid deserialization result: startDate")
			XCTAssertNil(test.endDate, "invalid deserialization result: endDate")
			XCTAssertEqual(test.caseTests.count, 0, "invalid deserialization result: caseTests")
		} catch let error as NSError {
			if let data = data {
				XCTAssertNil(error, "error while parsing json file: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
			}
		}
	}
	
}
