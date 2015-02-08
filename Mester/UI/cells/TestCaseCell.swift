//
//  TestCaseCell.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 23/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class TestCaseCell: UITableViewCell {
	
	var callback: ((AnyObject) -> Void)?
	weak var object: AnyObject?
	var button: UIButton = UIButton()
	var textLbl: UILabel = UILabel()
	var statusLbl: UILabel = UILabel()
	private var swiperView: SwiperView?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		swiperView = SwiperView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), leftInset: -95, rightInset: 0)
		var separatorView = UIView()
		separatorView.backgroundColor = ThemeDefault.colorForTint()
		self.contentView.addSubview(separatorView)
		self.contentView.addSubview(swiperView!)
		separatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
		swiperView!.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[swiper]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "swiper" : swiperView! ]))
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[swiper][sepView(==1)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "swiper" : swiperView!, "sepView" : separatorView ]))
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sepView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "sepView" : separatorView ]))
		self.contentView.bringSubviewToFront(swiperView!)
		textLbl.numberOfLines = 0;
		textLbl.lineBreakMode = .ByWordWrapping
		swiperView!.topmostView().addSubview(statusLbl)
		swiperView!.topmostView().addSubview(textLbl)
		statusLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
		textLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
		var constraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label][statusLbl]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "label" : textLbl, "statusLbl" : statusLbl ]) as [NSLayoutConstraint]
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "label" : textLbl ]) as [NSLayoutConstraint]
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[statusLbl]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "statusLbl" : statusLbl ]) as [NSLayoutConstraint]
		swiperView!.topmostView().addConstraints(constraints)
		button.setTitleColor(ThemeDefault.colorForButtonTitle(.Active), forState: .Normal)
		button.setTitleColor(ThemeDefault.colorForButtonTitle(.Selected), forState: .Highlighted)
		button.setTitleColor(ThemeDefault.colorForButtonTitle(.Inactive), forState: .Disabled)
		button.backgroundColor = ThemeDefault.colorForButtonBg(.Success)
		swiperView?.addSubview(button)
		button.setTranslatesAutoresizingMaskIntoConstraints(false)
		swiperView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button(>=100)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "button" : button ]))
		swiperView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "button" : button ]))
		swiperView?.rightCallback = { [weak self] in
			if let callback = self?.callback {
				if let object: AnyObject = self?.object {
					callback(object)
				}
			}
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let frame = self.contentView.bounds
		swiperView?.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - 1)
	}
	
	func setButtonVisibility(visible: Bool) {
		self.button.hidden = !visible
	}
	
	override func prepareForReuse() {
		self.callback = nil
		self.object = nil
		self.button.setTitle("", forState: .Normal)
		self.statusLbl.text = ""
		self.textLbl.text = ""
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
