//
//  CaseTest.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 22/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class CaseTest: NSObject, Mapping {
	
	let kFieldIdentifier = "id"
	let kFieldCreationDate = "creationDate"
	let kFieldStatus = "status"
	let kFieldStepTests = "stepTests"
	
	var creationDate: NSDate = NSDate()
	var identifier: String? = ""
	var test: Test?
	var status: TestStatus = TestStatus.Default
	var stepTests: [StepTest] = []
	
	func deserialize(dic: [String : AnyObject?]) {
		self.identifier = dic[kFieldIdentifier] as String?
		var status = dic[kFieldStatus] as String?
		self.status = TestStatus.testStatus(status)
		if let dateStr = dic[kFieldCreationDate] as String! {
			var dateFormatter = Common.dateFormatter
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			self.creationDate = dateFormatter.dateFromString(dateStr)!
		}
		let stepTestArr = dic[kFieldStepTests] as? [Dictionary<String, AnyObject>]
		if stepTestArr != nil {
			for stepTestDic in stepTestArr! {
				var stepTest = StepTest()
				stepTest.deserialize(stepTestDic)
				stepTest.caseTest = self
				self.stepTests.append(stepTest)
			}
		}
	}
	
	func serialize() -> [String : AnyObject] {
		return [:]
	}
	
}
