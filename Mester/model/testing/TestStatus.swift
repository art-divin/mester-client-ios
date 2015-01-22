//
//  TestStatus.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 22/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

enum TestStatus : String {
	case Default = "default"
	case Failed = "failed"
	case Succeed = "succeed"
	
	static func testStatus(status: String!) -> TestStatus {
		switch (status) {
		case TestStatus.Default.rawValue: return TestStatus.Default
		case TestStatus.Failed.rawValue: return TestStatus.Failed
		case TestStatus.Succeed.rawValue: return TestStatus.Succeed
		default: return TestStatus.Default
		}
	}
}
