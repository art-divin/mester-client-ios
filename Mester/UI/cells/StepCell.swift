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
	var textLbl: UILabel = UILabel()
	var statusLbl: UILabel = UILabel()
	private var swiperView: SwiperView?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		swiperView = SwiperView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), leftInset: -95, rightInset: -95)
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
		textLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
		swiperView!.topmostView().addSubview(textLbl)
		swiperView!.topmostView().addSubview(statusLbl)
		statusLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
		textLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
		var constraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label][statusLbl]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "label" : textLbl, "statusLbl" : statusLbl ]) as [NSLayoutConstraint]
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "label" : textLbl ]) as [NSLayoutConstraint]
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[statusLbl]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "statusLbl" : statusLbl ]) as [NSLayoutConstraint]
		swiperView!.topmostView().addConstraints(constraints)
		buttonSucceed.setTitleColor(ThemeDefault.colorForButtonTitle(.Success), forState: .Normal)
		buttonFail.setTitleColor(ThemeDefault.colorForButtonTitle(.Failure), forState: .Normal)
		buttonSucceed.backgroundColor = ThemeDefault.colorForButtonBg(.Success)
		buttonFail.backgroundColor = ThemeDefault.colorForButtonBg(.Failure)
		swiperView!.addSubview(buttonSucceed);
		swiperView!.addSubview(buttonFail);
		buttonSucceed.setTranslatesAutoresizingMaskIntoConstraints(false)
		buttonFail.setTranslatesAutoresizingMaskIntoConstraints(false)
		swiperView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[succ(>=100)]", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "succ" : buttonSucceed ]))
		swiperView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[fail(>=100)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "fail" : buttonFail ]))
		swiperView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "button" : buttonFail ]))
		swiperView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "button" : buttonSucceed ]))
		swiperView?.leftCallback = { [weak self] in
			if let callback = self?.succeedCallback {
				if let object: AnyObject = self?.object {
					callback(object)
				}
			}
		}
		swiperView?.rightCallback = { [weak self] in
			if let callback = self?.failCallback {
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
		self.buttonFail.hidden = !visible
		self.buttonSucceed.hidden = !visible
		self.swiperView?.hidden = !visible;
	}
	
	override func prepareForReuse() {
		self.succeedCallback = nil
		self.failCallback = nil
		self.object = nil
		self.textLbl.text = ""
		self.statusLbl.text = ""
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
