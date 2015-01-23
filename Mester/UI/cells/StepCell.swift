//
//  StepCell.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 23/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class StepCell: UITableViewCell {

	var succeedCallback: ((AnyObject) -> Void)?
	var failCallback: ((AnyObject) -> Void)?
	weak var object: AnyObject?
	var buttonFail: UIButton = UIButton()
	var buttonSucceed: UIButton = UIButton()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		buttonSucceed.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
		buttonFail.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
		buttonSucceed.setTitleColor(UIColor.blackColor(), forState: .Normal)
		buttonFail.setTitleColor(UIColor.blackColor(), forState: .Normal)
		self.contentView.addSubview(buttonSucceed);
		self.contentView.addSubview(buttonFail);
		buttonSucceed.setTranslatesAutoresizingMaskIntoConstraints(false)
		buttonFail.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[succ][fail]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "succ" : buttonSucceed, "fail" : buttonFail ]))
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "button" : buttonFail ]))
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "button" : buttonSucceed ]))
    }
	
	func setButtonVisibility(visible: Bool) {
		self.buttonFail.hidden = !visible
		self.buttonSucceed.hidden = !visible
	}
	
	override func prepareForReuse() {
		self.succeedCallback = nil
		self.failCallback = nil
		self.object = nil
	}
	
	func buttonTapped(sender : AnyObject?) {
		switch (sender as UIButton){
		case self.buttonFail:
			if let callback = self.failCallback {
				if self.object != nil {
					callback(self.object!)
				}
			}
			break
		case self.buttonSucceed:
			if let callback = self.succeedCallback {
				if self.object != nil {
					callback(self.object!)
				}
			}
			break
		default: break;
		}
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
