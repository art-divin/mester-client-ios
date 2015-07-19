//
//  ProjectTests.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/07/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit
import XCTest

import Mester

class ProjectTests: XCTestCase {

    override func setUp() {
        super.setUp()
		
    }
    
    override func tearDown() {
		
        super.tearDown()
    }

	func testProjectDeserializeSuccess() {
		let bundle = NSBundle(forClass: self.dynamicType)
		XCTAssertNotNil(bundle, "invalid bundle provided")
		let url = bundle.URLForResource("project", withExtension: "json")
		XCTAssertNotNil(url, "invalid url provided")
		let dic = NSDictionary(contentsOfURL: url!)
		XCTAssertNotNil(dic, "could not load json file")
		let project = Project()
		project.deserialize(dic as! Dictionary<String, AnyObject>)
		XCTAssertNotNil(project.identifier, "invalid deserialization result: identifier")
		XCTAssertNotNil(project.creationDate, "invalid deserialization result: creationDate")
		XCTAssertNotNil(project.name, "invalid deserialization result: name")
	}

}
