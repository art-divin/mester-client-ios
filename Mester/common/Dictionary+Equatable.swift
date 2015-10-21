//
//  Dictionary+Equatable.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 19/07/15.
//  Copyright © 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

func ==<T: Equatable, K1: Hashable, K2: Hashable>(lhs: [K1: [K2: T]], rhs: [K1: [K2 : T]]) -> Bool {
	if lhs.count != rhs.count {
		return false
	}
	for (key, lhsub) in lhs {
		if let rhsub = rhs[key] {
			if lhsub != rhsub {
				return false
			}
		} else {
			return false
		}
	}
	return true
}
