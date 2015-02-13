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
typealias ObjectCompletionBlock = (AnyObject?, XTResponseError?) -> Void

class ObjectManager: NSObject {
	private class func setup() {
		struct Token {
			static var token: dispatch_once_t = 0
		}
		dispatch_once(&Token.token, { () -> Void in
			RESTManager.setupWithConfiguration { () -> XTConfiguration! in
				return XTConfiguration(pairs: { () -> [AnyObject]! in
					return [ XTConfigurationPair(type: .Dev, URL: NSURL(string: "http://localhost:8080")),
							XTConfigurationPair(type: .Prod, URL: NSURL(string: "http://ec2-54-69-226-55.us-west-2.compute.amazonaws.com:8080")) ]
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
		RESTManager.fetchTestCases(project.identifier) { result, error in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			var testCaseArr: [TestCase] = []
			for testCaseDic in (result as NSArray) as Array {
				let dic = testCaseDic as Dictionary<String, AnyObject>
				let testCase = TestCase()
				testCase.project = project
				testCase.deserialize(dic)
				testCaseArr.append(testCase)
			}
			project.testCases = testCaseArr
			completionBlock(testCaseArr, error)
		}
	}
	
	class func createProject(project: Project!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		var projectDic = project.serialize()
		RESTManager.createProject(project: projectDic) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			completionBlock(result as [AnyObject]?, error)
		}
	}
	
	class func deleteProject(project: Project!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		RESTManager.deleteProject(project.identifier) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			completionBlock(result as [AnyObject]?, error)
		}
	}
	
	class func createTestCase(testCase: TestCase!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		var testCaseDic = testCase.serialize()
		RESTManager.createTestCase(testCase: testCaseDic) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			completionBlock(result as [AnyObject]?, error)
		}
	}
	
	class func deleteTestCase(testCase: TestCase!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		RESTManager.deleteTestCase(testCase.identifier, completionBlock: { (result, error) -> () in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			// TODO: proper error handling
			completionBlock(result as [AnyObject]?, error)
		})
	}
	
	class func createTestStep(testStep: TestStep!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		var testStepDic = testStep.serialize()
		RESTManager.createTestStep(testStep: testStepDic) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			completionBlock(result as [AnyObject]?, error)
		}
	}
	
	class func deleteTestStep(testStep: TestStep!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		var testStepDic = testStep.serialize()
		RESTManager.deleteTestStep(testStep.identifier, completionBlock: { (result, error) -> () in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			// TODO: proper error handling
			completionBlock(result as [AnyObject]?, error)
		})
	}
	
	class func fetchTestSteps(testCase: TestCase!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		RESTManager.fetchTestSteps(testCase.identifier) { result, error in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			var testStepArr: [TestStep] = []
			for testStepDic in (result as NSArray) as Array {
				let dic = testStepDic as Dictionary<String, AnyObject>
				let testStep = TestStep()
				testStep.testCase = testCase
				testStep.deserialize(dic)
				testStepArr.append(testStep)
			}
			testCase.steps = testStepArr
			completionBlock(testStepArr, error)
		}
	}
	
	class func fetchTests(project: Project!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		RESTManager.fetchTests(project.identifier) { result, error in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			var testArr: [Test] = []
			for testDic in (result as NSArray) as Array {
				let dic = testDic as Dictionary<String, AnyObject>
				let test = Test()
				test.project = project
				test.deserialize(dic)
				testArr.append(test)
			}
			project.tests = testArr
			completionBlock(testArr, error)
		}
	}
	
	class func createTest(project: Project!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		RESTManager.createTest(project.identifier) { result, error in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			var testArr: [Test] = []
			// TODO: handle response
			completionBlock([], error)
		}
	}
	
	class func startTest(test: Test!, completionBlock: ObjectCompletionBlock!) {
		ObjectManager.setup()
		RESTManager.startTest(test.identifier) { result, error in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			var testDic = result as [String : AnyObject]
			var newTest = Test()
			newTest.project = test.project
			newTest.deserialize(testDic)
			newTest.project?.updateTest(newTest)
			completionBlock(newTest, error)
		}
	}
	
	class func submitTest(test: Test!, completionBlock: ObjectCompletionBlock!) {
		ObjectManager.setup()
		var testDic = test.serialize()
		RESTManager.submitTest(test: testDic, testID: test.identifier) { result, error in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			var testDic = result as [String : AnyObject]
			var newTest = Test()
			newTest.project = test.project
			newTest.deserialize(testDic)
			newTest.project?.updateTest(newTest)
			completionBlock(newTest, error)
		}
	}
	
	class func fetchCaseTest(caseTest: CaseTest!, completionBlock: ObjectCompletionBlock!) {
		ObjectManager.setup()
		var caseTestDic = caseTest.serialize()
		RESTManager.fetchCaseTest(caseTest.identifier) { result, error in
			if let err = error {
				completionBlock(nil, error)
				return
			}
			var caseTestDic = result as [String : AnyObject]
			caseTest.deserialize(caseTestDic)
			completionBlock(caseTest, error)
		}
	}
	
}
