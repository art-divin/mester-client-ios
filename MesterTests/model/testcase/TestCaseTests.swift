//
//  TestCaseTests.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 20/07/15.
//  Copyright © 2015 Ruslan Alikhamov. All rights reserved.
//

import XCTest

@testable import Mester

class TestCaseTests: XCTestCase {
	
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
		let data = loadData("testcase", ext: "success")
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
			let dic = json as! Dictionary<String, AnyObject>
			let result = dic["result"] as! [AnyObject]
			let testCase = TestCase()
			for testCaseDic in result {
				testCase.deserialize(testCaseDic as! Dictionary<String, AnyObject>)
				XCTAssertNotNil(testCase.identifier, "invalid deserialization result: identifier")
			}
		} catch let error as NSError {
			if let data = data {
				XCTAssertNil(error, "error while parsing json file: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
			}
		}
	}
	
	func testDeserializeFailure() {
		let data = loadData("testcase", ext: "failure")
		
	}
	
	func testSerializeSuccess() {
	}
	
	func testSerializeFailure() {
	}
	
}