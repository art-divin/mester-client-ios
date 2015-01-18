//
//  RESTManager.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 17/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit
import Networking

class RESTManager: XTOperationManager {
	
	class func fetchProjects(completionBlock: (AnyObject?, XTResponseError?) -> ()) {
        let comps: NSURLComponents = RESTManager.URLComponents()
		comps.path = "/projects"
		let operation = XTRequestOperation(URL: comps.URL, type: .GET, dataDic: nil) { responseObj, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			var result: AnyObject? = responseObj?["result"]
			if !(result is NSArray) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj["status"]
				let statusStr = status as? NSString
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		RESTManager.scheduleOperation(operation);
    }
	
	class func fetchTestCases(projectID: String, completionBlock: (AnyObject?, XTResponseError?) -> ()) {
		let comps: NSURLComponents = RESTManager.URLComponents()
		comps.path = "/project/\(projectID)/testcases"
		let operation = XTRequestOperation(URL: comps.URL, type: .GET, dataDic: nil) { responseObj, responseError in
			var error: XTResponseError? = nil;
			if let err = responseError {
				error = XTResponseError(code: err.code, message: err.localizedDescription)
			}
			var result: AnyObject? = responseObj?["result"]
			if !(result is NSArray) {
				error = XTResponseError(errorCode: .InvalidResponseFormat, message: "Invalid response")
				completionBlock(nil, error)
				return;
			} else {
				let status: AnyObject? = responseObj["status"]
				let statusStr = status as? String
				if statusStr != "ok" {
					error = XTResponseError(errorCode: .ValidationError, message: "Invalid request format")
				}
			}
			completionBlock(result, error)
		}
		RESTManager.scheduleOperation(operation);
	}
}
