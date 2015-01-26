//
//  UIManager.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 17/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

enum ElementState {
	case Active, Selected, Inactive, Failure, Success
}

protocol Theme {
	class func colorForTint() -> UIColor!;
	class func colorForNavBg() -> UIColor!;
	class func colorForButtonBg(state: ElementState) -> UIColor!
	class func colorForButtonTitle(state: ElementState) -> UIColor!
	class func colorForCellText(state: ElementState) -> UIColor!
	class func colorForCellBg(state: ElementState) -> UIColor!
	class func heightForCell() -> CGFloat
}

class ThemeDefault: Theme {
	class func colorFromHEX(value: UInt64, alpha: Float) -> UIColor! {
		let b = value & 0xFF
		let g = (value >> 8) & 0xFF
		let r = (value >> 16) & 0xFF
		return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
	}
	
	class func colorForTint() -> UIColor! {
		return colorFromHEX(0x669966, alpha: 1.0)
	}
	
	class func colorForNavBg() -> UIColor! {
		return colorFromHEX(0x333333, alpha: 1.0)
	}
	
	class func colorForButtonBg(state: ElementState) -> UIColor! {
		switch state {
		case .Active: return colorFromHEX(0xffffff, alpha: 0.5)
		case .Selected: return colorFromHEX(0x34ACAF, alpha: 0.5)
		case .Inactive: return colorFromHEX(0xD1CAB0, alpha: 0.5)
		case .Failure: return colorFromHEX(0x8C001A, alpha: 1.0)
		case .Success: return colorFromHEX(0x006699, alpha: 1.0)
		}
	}
	
	class func colorForButtonTitle(state: ElementState) -> UIColor! {
		switch state {
		case .Active: return colorFromHEX(0x669966, alpha: 1.0)
		case .Selected: return colorFromHEX(0x669966, alpha: 0.5)
		case .Inactive: return colorFromHEX(0x669966, alpha: 0.5)
		case .Failure: return colorFromHEX(0x8C001A, alpha: 1.0)
		case .Success: return colorFromHEX(0x006699, alpha: 1.0)
		}
	}
	
	class func colorForCellText(state: ElementState) -> UIColor! {
		switch state {
		case .Active: return colorFromHEX(0x34ACAF, alpha: 1.0)
		case .Selected: return colorFromHEX(0x34ACAF, alpha: 0.5)
		case .Inactive: return colorFromHEX(0xD1CAB0, alpha: 0.5)
		case .Failure: return colorFromHEX(0x8C001A, alpha: 1.0)
		case .Success: return colorFromHEX(0x006699, alpha: 1.0)
		}
	}
	
	class func colorForCellBg(state: ElementState) -> UIColor! {
		switch state {
		case .Active: return colorFromHEX(0xffffff, alpha: 1.0)
		case .Selected: return colorFromHEX(0xffffff, alpha: 0.5)
		case .Inactive: return colorFromHEX(0xffffff, alpha: 0.5)
		case .Failure: return colorFromHEX(0x8C001A, alpha: 1.0)
		case .Success: return colorFromHEX(0x006699, alpha: 1.0)
		}
	}
	
	class func heightForCell() -> CGFloat {
		return 55.0
	}
}
