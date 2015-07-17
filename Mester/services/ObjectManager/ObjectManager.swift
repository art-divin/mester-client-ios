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
	
	private static var manager: RESTManager?
	
	class func setup() {
		let manager = RESTManager()
		manager.setupWithConfiguration { () -> XTConfiguration! in
			return XTConfiguration(pairs: { () -> [AnyObject]! in
				return [ XTConfigurationPair(type: .Dev, URL: NSURL(string: "http://localhost:8080")),
					XTConfigurationPair(type: .Prod, URL: NSURL(string: "")) ]
				},
				type: .Dev)
		}
		ObjectManager.manager = manager
	}
	
	class func fetchProjects(completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		ObjectManager.manager?.fetchProjects({ result, error in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			var projectArr: [Project] = []
			for projectDic in (result as! NSArray) as Array {
				let dic = projectDic as! Dictionary<String, AnyObject>
				let project = Project()
				project.deserialize(dic)
				projectArr.append(project)
			}
			completionBlock(projectArr, error)
		})
	}
	
	class func fetchTestCases(project: Project!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		ObjectManager.manager?.fetchTestCases(project.identifier) { result, error in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			var testCaseArr: [TestCase] = []
			for testCaseDic in (result as! NSArray) as Array {
				let dic = testCaseDic as! Dictionary<String, AnyObject>
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
		let projectDic = project.serialize()
		ObjectManager.manager?.createProject(project: projectDic) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			completionBlock(result as! [AnyObject]?, error)
		}
	}
	
	class func deleteProject(project: Project!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		ObjectManager.manager?.deleteProject(project.identifier) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			completionBlock(result as! [AnyObject]?, error)
		}
	}
	
	class func createTestCase(testCase: TestCase!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		let testCaseDic = testCase.serialize()
		ObjectManager.manager?.createTestCase(testCase: testCaseDic) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			completionBlock(result as! [AnyObject]?, error)
		}
	}
	
	class func deleteTestCase(testCase: TestCase!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		ObjectManager.manager?.deleteTestCase(testCase.identifier, completionBlock: { (result, error) -> () in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			// TODO: proper error handling
			completionBlock(result as! [AnyObject]?, error)
		})
	}
	
	class func createTestStep(testStep: TestStep!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		let testStepDic = testStep.serialize()
		ObjectManager.manager?.createTestStep(testStep: testStepDic) { (result, error) -> () in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			completionBlock(result as! [AnyObject]?, error)
		}
	}
	
	class func deleteTestStep(testStep: TestStep!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		ObjectManager.manager?.deleteTestStep(testStep.identifier, completionBlock: { (result, error) -> () in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			// TODO: proper error handling
			completionBlock(result as! [AnyObject]?, error)
		})
	}
	
	class func fetchTestSteps(testCase: TestCase!, completionBlock: ArrayCompletionBlock!) {
		ObjectManager.setup()
		ObjectManager.manager?.fetchTestSteps(testCase.identifier) { result, error in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			var testStepArr: [TestStep] = []
			for testStepDic in (result as! NSArray) as Array {
				let dic = testStepDic as! Dictionary<String, AnyObject>
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
		ObjectManager.manager?.fetchTests(project.identifier) { result, error in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			var testArr: [Test] = []
			for testDic in (result as! NSArray) as Array {
				let dic = testDic as! Dictionary<String, AnyObject>
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
		ObjectManager.manager?.createTest(project.identifier) { result, error in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			var testArr: [Test] = []
			// TODO: handle response
			completionBlock([], error)
		}
	}
	
	class func submitTest(test: Test!, completionBlock: ObjectCompletionBlock!) {
		ObjectManager.setup()
		let testDic = test.serialize()
		ObjectManager.manager?.submitTest(test: testDic, testID: test.identifier) { result, error in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			let testDic = result as! [String : AnyObject]
			let newTest = Test()
			newTest.project = test.project
			newTest.deserialize(testDic)
			newTest.project?.updateTest(newTest)
			completionBlock(newTest, error)
		}
	}
	
	class func fetchCaseTest(caseTest: CaseTest!, completionBlock: ObjectCompletionBlock!) {
		ObjectManager.setup()
		ObjectManager.manager?.fetchCaseTest(caseTest.identifier) { result, error in
			if let err = error {
				completionBlock(nil, err)
				return
			}
			let caseTestDic = result as! [String : AnyObject]
			caseTest.deserialize(caseTestDic)
			completionBlock(caseTest, error)
		}
	}
	
}
