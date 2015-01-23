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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
		button.setTitleColor(UIColor.blackColor(), forState: .Normal)
		self.contentView.addSubview(button);
		button.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "button" : button ]))
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "button" : button ]))
    }
	
	override func prepareForReuse() {
		self.callback = nil
		self.object = nil
		self.button.setTitle("", forState: .Normal)
	}

	func buttonTapped(sender: AnyObject?) {
		if let callback = self.callback {
			if self.object != nil {
				callback(self.object!)
			}
		}
	}
	
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
