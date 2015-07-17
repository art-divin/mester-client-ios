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
	let kFieldTestStepID = "testStepId"
	
	var creationDate: NSDate = NSDate()
	var identifier: String? = ""
	var test: Test?
	var status: TestStatus = TestStatus.Default
	var stepTests: [StepTest] = []
	var testCase: TestCase?
	
	func deserialize(dic: [String : AnyObject?]) {
		self.identifier = dic[kFieldIdentifier] as! String?
		let status = dic[kFieldStatus] as! String?
		self.status = TestStatus.testStatus(status)
		if let dateStr = dic[kFieldCreationDate] as? String? {
			let dateFormatter = Common.dateFormatter
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			self.creationDate = dateFormatter.dateFromString(dateStr!)!
		}
		let stepTestArr = dic[kFieldStepTests] as? [Dictionary<String, AnyObject>]
		if stepTestArr != nil {
			self.stepTests.removeAll(keepCapacity: false)
			for stepTestDic in stepTestArr! {
				let stepTest = StepTest()
				let testStepID = stepTestDic[kFieldTestStepID] as! String?
				if testStepID != nil {
					var foundArr = self.testCase?.steps.filter({ (testStep) -> Bool in
						testStep.identifier == testStepID
					})
					let testStep = foundArr?.first
					stepTest.testStep = testStep
				}
				stepTest.caseTest = self
				stepTest.deserialize(stepTestDic)
				self.stepTests.append(stepTest)
			}
		}
	}
	
	func serialize() -> [String : AnyObject] {
		if self.identifier != nil {
			var steps: [[String : AnyObject]] = []
			for step in self.stepTests {
				let stepDic = step.serialize()
				steps.append(stepDic)
			}
			return [ kFieldIdentifier : self.identifier!, kFieldStepTests : steps ]
		}
		return [:]
	}
	
}
