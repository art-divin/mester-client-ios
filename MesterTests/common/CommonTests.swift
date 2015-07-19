//
//  CommonTests.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/07/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit
import XCTest
import Mester

class CommonTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testDateFormatter() {
		let dateFormatter = Common.dateFormatter
		let dateFormatterCopy = Common.dateFormatter
		
		XCTAssertEqual(dateFormatter, dateFormatterCopy, "invalid behaviour of the singleton")
	}

}
