//
//  TestStep.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class TestStep: NSObject, Mapping {
	
	let kFieldIdentifier = "id"
	let kFieldText = "text"
	let kFieldNumber = "number"
	let kFieldTestCaseID = "testCaseId"
	
	var text: String?
	var number: Int?
	var identifier: String?
	var testCase: TestCase?
	
	func deserialize(dic: [String : AnyObject?]) {
		self.identifier = dic[kFieldIdentifier] as String?
		self.number = dic[kFieldNumber] as Int?
		self.text = dic[kFieldText] as String?
	}
	
	func serialize() -> [String : String] {
		return [:]
	}
}
