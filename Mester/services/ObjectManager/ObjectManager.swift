//
//  ObjectManager.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit
import Networking

typealias ArrayCompletionBlock = ([AnyObject]?, XTResponseError?) -> Void
typealias DictionaryCompletionBlock = ([String: AnyObject?]?, XTResponseError?) -> Void

class ObjectManager: NSObject {
	private class func setup() {
		struct Token {
			static var token: dispatch_once_t = 0
		}
		dispatch_once(&Token.token, { () -> Void in
			RESTManager.setupWithConfiguration { () -> XTConfiguration! in
				return XTConfiguration(pairs: { () -> [AnyObject]! in
					return [ XTConfigurationPair(type: .Dev, URL: NSURL(string: "http://localhost:8080")) ]
					},
					type: .Dev)
			}
		})
	}
	class func fetchProjects(completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		RESTManager.fetchProjects({ result, error in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			var projectArr: [Project] = []
			for projectDic in (result as NSArray) as Array {
				let dic = projectDic as Dictionary<String, AnyObject>
				let project = Project()
				project.deserialize(dic)
				projectArr.append(project)
			}
			completionBlock(projectArr, error)
		})
	}
	
	class func fetchTestCases(project: Project!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		RESTManager.fetchTestCases(project.identifier!) { result, error in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			var testCaseArr: [TestCase] = []
			for testCaseDic in (result as NSArray) as Array {
				let dic = testCaseDic as Dictionary<String, AnyObject>
				let testCase = TestCase()
				testCase.deserialize(dic)
				testCaseArr.append(testCase)
			}
			completionBlock(testCaseArr, error)
		}
	}
	
	class func createProject(project: Project!, completionBlock: DictionaryCompletionBlock!) {
		ObjectManager.setup()
		var projectDic = project.serialize()
		RESTManager.createProject(project: projectDic) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			completionBlock(result as Dictionary<String, AnyObject>?, error)
		}
	}
	
	class func deleteProject(project: Project!, completionBlock: DictionaryCompletionBlock!) {
		ObjectManager.setup()
		RESTManager.deleteProject(project.identifier) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			completionBlock(result as Dictionary<String, AnyObject>?, error)
		}
	}
}
