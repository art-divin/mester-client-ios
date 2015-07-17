//
//  RESTManager.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 17/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit
import Networking

typealias CompletionBlock = (AnyObject?, XTResponseError?) -> ()

class RESTManager: XTOperationManager {
	
	func fetchProjects(completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/projects"
		let operation = XTRequestOperation(URL: comps.URL, type: .GET, dataDic: nil, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let result: AnyObject? = responseObj?["result"]
			if !(result is NSArray) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj?["status"]
				let statusStr = status as? NSString
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		self.scheduleOperation(operation);
	}
	
	func fetchTestCases(projectID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/project/\(projectID)/testcases"
		let operation = XTRequestOperation(URL: comps.URL, type: .GET, dataDic: nil, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let result: AnyObject? = responseObj?["result"]
			if !(result is NSArray) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj?["status"]
				let statusStr = status as? String
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		self.scheduleOperation(operation);
	}
	
	func createProject(project projectDic: [String: AnyObject]!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/project"
		let operation = XTRequestOperation(URL: comps.URL, type: .POST, dataDic: projectDic, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let status: AnyObject? = responseObj?["status"]
			let statusStr = status as? String
			if statusStr != "ok" {
				error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
			}
			completionBlock(nil, error)
		}
		self.scheduleOperation(operation);
	}
	
	func deleteProject(projectID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/project/\(projectID)"
		let operation = XTRequestOperation(URL: comps.URL, type: .DELETE, dataDic: nil, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let status: AnyObject? = responseObj?["status"]
			let statusStr = status as? String
			if statusStr != "ok" {
				error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
			}
			completionBlock(nil, error)
		}
		self.scheduleOperation(operation);
	}
	
	func createTestCase(testCase testCaseDic: [String: AnyObject]!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/testcase"
		let operation = XTRequestOperation(URL: comps.URL, type: .POST, dataDic: testCaseDic, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let status: AnyObject? = responseObj?["status"]
			let statusStr = status as? String
			if statusStr != "ok" {
				error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
			}
			completionBlock(nil, error)
		}
		self.scheduleOperation(operation);
	}
	
	func deleteTestCase(testCaseID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/testcase/\(testCaseID)"
		let operation = XTRequestOperation(URL: comps.URL, type: .DELETE, dataDic: nil, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let status: AnyObject? = responseObj?["status"]
			let statusStr = status as? String
			if statusStr != "ok" {
				error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
			}
			completionBlock(nil, error)
		}
		self.scheduleOperation(operation);
	}
	
	func createTestStep(testStep testStepDic: [String: AnyObject]!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/step"
		let operation = XTRequestOperation(URL: comps.URL, type: .POST, dataDic: testStepDic, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let status: AnyObject? = responseObj?["status"]
			let statusStr = status as? String
			if statusStr != "ok" {
				error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
			}
			completionBlock(nil, error)
		}
		self.scheduleOperation(operation);
	}
	
	func deleteTestStep(testStepID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/step/\(testStepID)"
		let operation = XTRequestOperation(URL: comps.URL, type: .DELETE, dataDic: nil, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let status: AnyObject? = responseObj?["status"]
			let statusStr = status as? String
			if statusStr != "ok" {
				error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
			}
			completionBlock(nil, error)
		}
		self.scheduleOperation(operation);
	}
	
	func fetchTestSteps(testCaseID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/testcase/\(testCaseID)/steps"
		let operation = XTRequestOperation(URL: comps.URL, type: .GET, dataDic: nil, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let result: AnyObject? = responseObj?["result"]
			if !(result is NSArray) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj?["status"]
				let statusStr = status as? String
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		self.scheduleOperation(operation);
	}
	
	func fetchTests(projectID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/project/\(projectID)/tests"
		let operation = XTRequestOperation(URL: comps.URL, type: .GET, dataDic: nil, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let result: AnyObject? = responseObj?["result"]
			if !(result is NSArray) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj?["status"]
				let statusStr = status as? String
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		self.scheduleOperation(operation);
	}
	
	func createTest(projectID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/project/\(projectID)/test"
		let operation = XTRequestOperation(URL: comps.URL, type: .POST, dataDic: nil, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let result: AnyObject? = responseObj?["result"]
			if !(result is NSDictionary) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj?["status"]
				let statusStr = status as? String
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		self.scheduleOperation(operation);
	}
	
	func submitTest(test testDic: [String: AnyObject]!, testID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/test/\(testID)/submit"
		let operation = XTRequestOperation(URL: comps.URL, type: .PUT, dataDic: testDic, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let result: AnyObject? = responseObj?["result"]
			if !(result is NSDictionary) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj?["status"]
				let statusStr = status as? String
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		self.scheduleOperation(operation);
	}
	
	func fetchCaseTest(caseTestID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = self.URLComponents()
		comps.path = "/test/casetest/\(caseTestID)"
		let operation = XTRequestOperation(URL: comps.URL, type: .GET, dataDic: nil, headerDic: nil, contentType: "application/json") { responseObj, headerDic, responseError in
			var error: XTResponseError? = nil
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let result: AnyObject? = responseObj?["result"]
			if !(result is NSDictionary) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj?["status"]
				let statusStr = status as? String
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		self.scheduleOperation(operation);
	}
	
}
