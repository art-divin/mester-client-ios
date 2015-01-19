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
	let kFieldCreationDate = "creationDate"
	
	var text: String = ""
	var number: Int = 0
	var identifier: String = ""
	var creationDate: NSDate? = NSDate()
	var testCase: TestCase?
	
	func deserialize(dic: [String : AnyObject?]) {
		self.identifier = dic[kFieldIdentifier] as String!
		self.number = dic[kFieldNumber] as Int!
		self.text = dic[kFieldText] as String!
		if let dateStr = dic[kFieldCreationDate] as String! {
			var dateFormatter = Common.dateFormatter
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			self.creationDate = dateFormatter.dateFromString(dateStr)!
		}
	}
	
	func serialize() -> [String : AnyObject] {
		var testCaseDic = [String : AnyObject]()
		testCaseDic[kFieldText] = self.text
		testCaseDic[kFieldTestCaseID] = self.testCase?.identifier
		testCaseDic[kFieldNumber] = self.number
		return testCaseDic
	}
}
