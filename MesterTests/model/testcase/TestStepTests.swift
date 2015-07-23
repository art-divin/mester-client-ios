//
//  TestStepTests.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 21/07/15.
//  Copyright © 2015 Ruslan Alikhamov. All rights reserved.
//

import XCTest

@testable import Mester

class TestStepTests: XCTestCase {
	
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
		let data = loadData("teststep", ext: "success")
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
			let dic = json as! Dictionary<String, AnyObject>
			let testStep = TestStep()
			testStep.deserialize(dic)
			XCTAssertNotNil(testStep.identifier, "invalid deserialization result: identifier")
		} catch let error as NSError {
			if let data = data {
				XCTAssertNil(error, "error while parsing json file: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
			}
		}
	}
	
	func testDeserializeFailure() {
		let data = loadData("teststep", ext: "failure")
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
			let dic = json as! Dictionary<String, AnyObject>
			let testStep = TestStep()
			testStep.deserialize(dic)
			XCTAssertNil(testStep.identifier, "invalid deserialization result: identifier")
			XCTAssertNil(testStep.testCase, "invalid deserialization result: testCase")
			XCTAssertNil(testStep.number, "invalid deserialization result: number")
			XCTAssertNil(testStep.text, "invalid deserialization result: text")
		} catch let error as NSError {
			if let data = data {
				XCTAssertNil(error, "error while parsing json file: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
			}
		}
	}
	
	func testSerializeSuccess() {
		let project = Project()
		project.identifier = "1"
		let testCase = TestCase()
		testCase.project = project
		testCase.title = "title"
		testCase.identifier = "1"
		let testStep = TestStep()
		testStep.testCase = testCase
		testStep.text = "text"
		testStep.number = 1
		let dic = testStep.serialize()
		let testDic = [
			"testCaseId" : "1",
			"text" : "text",
			"number" : Int(1) ]
		XCTAssertEqual(dic, testDic, "incorrect serialization implementation")
	}
	
	func testSerializeFailure() {
		let project = Project()
		project.identifier = "1"
		let testCase = TestCase()
		testCase.project = project
		testCase.title = "title"
		testCase.identifier = "3"
		let testStep = TestStep()
		testStep.testCase = testCase
		testStep.text = "text"
		testStep.number = 1
		let dic = testStep.serialize()
		let testDic = [
			"testCaseId" : "1",
			"text" : "text",
			"number" : Int(2) ]
		XCTAssertNotEqual(dic, testDic, "incorrect serialization implementation")
	}
	
}
