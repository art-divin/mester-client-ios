//
//  Common.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class Common: NSObject {
	class var dateFormatter: NSDateFormatter {
		get {
			struct Token {
				static var dateFormatter: NSDateFormatter = NSDateFormatter()
			}
			return Token.dateFormatter
		}
	}
}
