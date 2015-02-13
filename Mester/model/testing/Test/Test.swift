//
//  Test.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 22/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class Test: NSObject, Mapping {
	
	let kFieldIdentifier = "id"
	let kFieldCreationDate = "creationDate"
	let kFieldStartDate = "startDate"
	let kFieldEndDate = "endDate";
	let kFieldCaseTests = "caseTests"
	let kFieldStatus = "status"
	let kFieldTestCase = "testCaseId"
	
	var identifier: String? = ""
	var creationDate: NSDate = NSDate()
	var startDate: NSDate?
	var endDate: NSDate?
	var caseTests: [CaseTest] = []
	var status: TestStatus = TestStatus.Default
	var project: Project?
	
	func deserialize(dic: [String : AnyObject?]) {
		self.identifier = dic[kFieldIdentifier] as String?
		var dateFormatter = Common.dateFormatter
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		if let dateStr = dic[kFieldCreationDate] as? String? {
			self.creationDate = dateFormatter.dateFromString(dateStr!)!
		}
		if let startDateStr = dic[kFieldStartDate] as? String? {
			self.startDate = dateFormatter.dateFromString(startDateStr!)!
		}
		if let endDateStr = dic[kFieldEndDate] as? String? {
			self.endDate = dateFormatter.dateFromString(endDateStr!)!
		}
		let caseTestArr = dic[kFieldCaseTests] as? [Dictionary<String, AnyObject>]
		if caseTestArr != nil {
			for caseTestDic in caseTestArr! {
				var caseTest = CaseTest()
				var testCaseID = caseTestDic[kFieldTestCase] as String?
				if testCaseID != nil {
					var foundArr = self.project?.testCases.filter({ (testCase) -> Bool in
						testCase.identifier == testCaseID
					})
					var testCase = foundArr?.first
					caseTest.testCase = testCase
				}
				caseTest.test = self
				caseTest.deserialize(caseTestDic)
				self.caseTests.append(caseTest)
			}
		}
		var status = dic[kFieldStatus] as String?
		self.status = TestStatus.testStatus(status)
	}

	func serialize() -> [String : AnyObject] {
		if self.identifier != nil {
			var cases: [[String : AnyObject]] = []
			for caseTest in self.caseTests {
				var caseDic = caseTest.serialize()
				cases.append(caseDic)
			}
			return [ kFieldCaseTests : cases ]
		}
		
		return [:]
	}
	
	func updateCaseTest(caseTest: CaseTest!) {
		let oldTestArr = self.caseTests.filter { (oldCaseTest) -> Bool in
			oldCaseTest.identifier == caseTest.identifier
		}
		if oldTestArr.count == 1 {
			let idx = find(self.caseTests, oldTestArr.first!)
			self.caseTests[idx!] = caseTest
		}
	}
	
}
