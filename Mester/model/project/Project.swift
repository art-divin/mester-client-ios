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
	
	var name: String?
	var identifier: String?
	var creationDate: NSDate?
	
	func deserialize(dic: [String : AnyObject?]) {
		self.name = dic[kFieldName] as? String
		self.identifier = dic[kFieldIdentifier] as? String
		if let dateStr = dic[kFieldDate] as? String {
			var dateFormatter = Common.dateFormatter
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			self.creationDate = dateFormatter.dateFromString(dateStr)
		}
	}
}
