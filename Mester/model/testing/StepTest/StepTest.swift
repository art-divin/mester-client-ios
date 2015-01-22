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
	
	func deserialize(dic: [String : AnyObject?]) {
		self.identifier = dic[kFieldIdentifier] as String?
		var status = dic[kFieldStatus] as String?
		self.status = TestStatus.testStatus(status)
	}
	
	func serialize() -> [String : AnyObject] {
		return [:]
	}
	
}
