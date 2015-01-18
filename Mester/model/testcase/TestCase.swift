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
	
	var title: String?
	var creationDate: NSDate?
	var identifier: String?
	
	func deserialize(dic: [String : AnyObject?]) {
		self.title = dic[kFieldTitle] as? String
		self.identifier = dic[kFieldIdentifier] as? String
		if let dateStr = dic[kFieldCreationDate] as? String {
			var dateFormatter = Common.dateFormatter
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			self.creationDate = dateFormatter.dateFromString(dateStr)
		}
	}
	
}
