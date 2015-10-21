//
//  StepTest.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 22/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class StepTest: NSObject, Mapping {
	
	let kFieldIdentifier = "id"
	let kFieldCreationDate = "creationDate"
	let kFieldStatus = "status"
	
	var identifier: String? = ""
	var status: TestStatus = TestStatus.Default
	var caseTest: CaseTest?
	var testStep: TestStep?
	var creationDate: NSDate = NSDate()
	
	func deserialize(dic: [String : AnyObject?]) {
		self.identifier = dic[kFieldIdentifier] as? String
		let status = dic[kFieldStatus] as? String
		self.status = TestStatus.testStatus(status)
		if let dateStr = dic[kFieldCreationDate] as? String {
			let dateFormatter = Common.dateFormatter
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
			self.creationDate = dateFormatter.dateFromString(dateStr)!
		}
	}
	
	func serialize() -> [String : AnyObject] {
		if self.identifier != nil {
			return [ kFieldIdentifier : self.identifier!, kFieldStatus : self.status.rawValue ]
		}
		return [:]
	}
	
}
