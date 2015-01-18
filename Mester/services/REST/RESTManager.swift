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
	
	class func fetchProjects(completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = RESTManager.URLComponents()
		comps.path = "/projects"
		let operation = XTRequestOperation(URL: comps.URL, type: .GET, dataDic: nil, contentType: "application/json") { responseObj, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			var result: AnyObject? = responseObj?["result"]?
			if !(result is NSArray) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj?["status"]?
				let statusStr = status as? NSString
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		RESTManager.scheduleOperation(operation);
	}
	
	class func fetchTestCases(projectID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = RESTManager.URLComponents()
		comps.path = "/project/\(projectID)/testcases"
		let operation = XTRequestOperation(URL: comps.URL, type: .GET, dataDic: nil, contentType: "application/json") { responseObj, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			var result: AnyObject? = responseObj?["result"]?
			if !(result is NSArray) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj?["status"]?
				let statusStr = status as? String
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		RESTManager.scheduleOperation(operation);
	}
	
	class func createProject(project projectDic: [String: String]!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = RESTManager.URLComponents()
		comps.path = "/project"
		let operation = XTRequestOperation(URL: comps.URL, type: .POST, dataDic: projectDic, contentType: "application/json") { responseObj, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let status: AnyObject? = responseObj?["status"]?
			let statusStr = status as? String
			if statusStr != "ok" {
				error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
			}
			completionBlock(nil, error)
		}
		RESTManager.scheduleOperation(operation);
	}
	
	class func deleteProject(projectID: String!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = RESTManager.URLComponents()
		comps.path = "/project/\(projectID)"
		let operation = XTRequestOperation(URL: comps.URL, type: .DELETE, dataDic: nil, contentType: "application/json") { responseObj, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let status: AnyObject? = responseObj?["status"]?
			let statusStr = status as? String
			if statusStr != "ok" {
				error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
			}
			completionBlock(nil, error)
		}
		RESTManager.scheduleOperation(operation);
	}
	
	class func createTestCase(testCase testCaseDic: [String: String]!, completionBlock: CompletionBlock!) {
		let comps: NSURLComponents = RESTManager.URLComponents()
		comps.path = "/testcase"
		let operation = XTRequestOperation(URL: comps.URL, type: .POST, dataDic: testCaseDic, contentType: "application/json") { responseObj, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			let status: AnyObject? = responseObj?["status"]?
			let statusStr = status as? String
			if statusStr != "ok" {
				error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
			}
			completionBlock(nil, error)
		}
		RESTManager.scheduleOperation(operation);
	}
}
