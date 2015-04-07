//
//  TestCase.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class TestCase: NSObject, Mapping {
	
	let kFieldTitle = "title"
	let kFieldIdentifier = "id"
	let kFieldCreationDate = "creationDate"
	let kFieldSteps = "steps"
	let kFieldProjectID = "projectId"
	
	var title: String? = ""
	var creationDate: NSDate = NSDate()
	var identifier: String? = ""
	var steps: [TestStep] = []
	var project: Project?
	
	func deserialize(dic: [String : AnyObject?]) {
		self.title = dic[kFieldTitle] as! String?
		self.identifier = dic[kFieldIdentifier] as! String?
		if let dateStr = dic[kFieldCreationDate] as? String? {
			var dateFormatter = Common.dateFormatter
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			self.creationDate = dateFormatter.dateFromString(dateStr!)!
		}
		let stepArr = dic[kFieldSteps] as? [Dictionary<String, AnyObject>]
		if stepArr != nil {
			for stepDic in stepArr! {
				var step = TestStep()
				step.testCase = self
				step.deserialize(stepDic)
				self.steps.append(step)
			}
		}
	}
	
	func serialize() -> [String : AnyObject] {
		var testCaseDic = [String : AnyObject]()
		testCaseDic[kFieldProjectID] = self.project?.identifier
		testCaseDic[kFieldTitle] = self.title
		return testCaseDic
	}
}
