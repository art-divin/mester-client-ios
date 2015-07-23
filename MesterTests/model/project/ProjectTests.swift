//
//  ProjectTests.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/07/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit
import XCTest

@testable import Mester

class ProjectTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		
	}
	
	override func tearDown() {
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
		let data = loadData("project", ext: "success")
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
			let dic = json as! Dictionary<String, AnyObject>
			let project = Project()
			project.deserialize(dic)
			XCTAssertNotNil(project.identifier, "invalid deserialization result: identifier")
			XCTAssertNotNil(project.creationDate, "invalid deserialization result: creationDate")
			XCTAssertNotNil(project.name, "invalid deserialization result: name")
		} catch let error as NSError {
			if let data = data {
				XCTAssertNil(error, "error while parsing json file: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
			}
		}
	}
	
	func testDeserializeFailure() {
		let data = loadData("project", ext: "failure")
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
			let dic = json as! Dictionary<String, AnyObject>
			let project = Project()
			project.deserialize(dic)
			XCTAssertNil(project.identifier, "invalid deserialization result: identifier")
			XCTAssertNotNil(project.creationDate, "invalid deserialization result: creationDate")
			XCTAssertNil(project.name, "invalid deserialization result: name")
			XCTAssertEqual(project.tests.count, 0, "invalid deserialization result: tests")
			XCTAssertEqual(project.testCases.count, 0, "invalid deserialization result: testCases")
		} catch let error as NSError {
			if let data = data {
				XCTAssertNil(error, "error while parsing json file: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
			}
		}
	}
	
	func testSerializeSuccess() {
		let project = Project()
		project.name = "Project 1"
		project.identifier = "1"
		let dic = project.serialize()
		let testDic = [ "name" : "Project 1" ]
		XCTAssertEqual(dic as! [String : String], testDic as [String : String], "incorrect serialization implementation")
	}
	
	func testSerializeFailure() {
		let project = Project()
		project.name = "Project 1"
		project.identifier = "1"
		let dic = project.serialize()
		let testDic = [
			"name" : "Project 2",
			"id" : "1" ]
		XCTAssertNotEqual(dic as! [String : String], testDic as [String : String], "incorrect serialization implementation")
	}
	
}
