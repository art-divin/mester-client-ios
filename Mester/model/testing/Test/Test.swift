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
		if let dateStr = dic[kFieldCreationDate] as String! {
			self.creationDate = dateFormatter.dateFromString(dateStr)!
		}
		if let startDateStr = dic[kFieldStartDate] as String! {
			self.startDate = dateFormatter.dateFromString(startDateStr)!
		}
		if let endDateStr = dic[kFieldEndDate] as String! {
			self.endDate = dateFormatter.dateFromString(endDateStr)!
		}
		let caseTestArr = dic[kFieldCaseTests] as? [Dictionary<String, AnyObject>]
		if caseTestArr != nil {
			for caseTestDic in caseTestArr! {
				var caseTest = CaseTest()
				caseTest.deserialize(caseTestDic)
				caseTest.test = self
				self.caseTests.append(caseTest)
			}
		}
		var status = dic[kFieldStatus] as String?
		self.status = TestStatus.testStatus(status)
	}
	
	func serialize() -> [String : AnyObject] {
		return [:]
	}
	
}
