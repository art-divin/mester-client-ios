//
//  Project.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class Project: NSObject, Mapping {
	
	let kFieldName = "name"
	let kFieldIdentifier = "id"
	let kFieldDate = "creationDate"
	
	var name: String? = ""
	var identifier: String? = ""
	var creationDate: NSDate = NSDate()
	var tests: [Test] = []
	var testCases: [TestCase] = []
	
	func updateTest(test: Test!) {
		var oldTestArr = self.tests.filter { (oldTest) -> Bool in
			test.identifier == oldTest.identifier
		}
		if oldTestArr.count == 1 {
			let idx = oldTestArr.indexOf(oldTestArr.first!)
			self.tests[idx!] = test
		}
	}
	
	func deserialize(dic: [String : AnyObject?]) {
		self.name = dic[kFieldName] as? String
		self.identifier = dic[kFieldIdentifier] as? String
		if let dateStr = dic[kFieldDate] as? String {
			let dateFormatter = Common.dateFormatter
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
			self.creationDate = dateFormatter.dateFromString(dateStr)!
		}
	}
	
	func serialize() -> [String : AnyObject] {
		var projectDic = [String : AnyObject]()
		projectDic[kFieldName] = self.name
		return projectDic
	}
}
