//
//  ProjectViewController.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
	
	@IBOutlet var nameHintLbl: UILabel!
	@IBOutlet var nameField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = NSLocalizedString("layouts.project.add.title", comment: "add project view title")
		
		var doneBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
		self.navigationItem.rightBarButtonItem = doneBtn
		
		self.nameHintLbl.text = NSLocalizedString("layouts.project.add.name.hint", comment: "project name hint lable title")
		self.nameField.placeholder = NSLocalizedString("layouts.project.add.name.field.placeholder", comment: "project name field placeholder")
	}
	
	func done(sender: AnyObject?) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
