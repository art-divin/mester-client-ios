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

	func testProjectDeserializeSuccess() {
		let bundle = NSBundle(forClass: self.dynamicType)
		XCTAssertNotNil(bundle, "invalid bundle provided")
		let url = bundle.URLForResource("project", withExtension: "json")
		XCTAssertNotNil(url, "invalid url provided")
		let data = NSData(contentsOfURL: url!)
		XCTAssertNotNil(data, "could not load json file")
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
			let dic = json as! Dictionary<String, AnyObject>
			
			let result = dic["result"] as! [AnyObject]
			for projectDic in result {
				let project = Project()
				project.deserialize(projectDic as! Dictionary<String, AnyObject>)
				XCTAssertNotNil(project.identifier, "invalid deserialization result: identifier")
				XCTAssertNotNil(project.creationDate, "invalid deserialization result: creationDate")
				XCTAssertNotNil(project.name, "invalid deserialization result: name")
			}
		} catch let error as NSError {
			XCTAssertNil(error, "error while parsing json file at URL: \(url)")
		}
	}

}
