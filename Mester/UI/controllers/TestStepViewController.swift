//
//  TestStepViewController.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 19/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class TestStepViewController: UIViewController {
	
	@IBOutlet var textHintLbl: UILabel!
	@IBOutlet var textField: UITextField!
	@IBOutlet var numberHintLbl: UILabel!
	@IBOutlet var numberValueLbl: UILabel!
	@IBOutlet var numberStepper: UIStepper!
	
	var testCase: TestCase? {
		didSet {
			self.testStep.testCase = testCase
		}
	}
	var callback: ((TestStep!) -> Void)?
	var testStep: TestStep = TestStep()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = NSLocalizedString("layouts.teststep.add.title", comment: "add teststep view title")
		
		let doneBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
		self.navigationItem.rightBarButtonItem = doneBtn
		
		self.textHintLbl.text = NSLocalizedString("layouts.teststep.add.text.hint", comment: "teststep text hint lable title")
		self.textField.placeholder = NSLocalizedString("layouts.teststep.add.text.field.placeholder", comment: "teststep text field placeholder")
		self.numberHintLbl.text = NSLocalizedString("layouts.teststep.add.number.hint", comment: "teststep number hint title")
		self.numberValueLbl.text = "\(self.testStep.number)"
		self.numberStepper.value = Double(self.testStep.number!)
		self.numberStepper.addTarget(self, action: "handleStepper:", forControlEvents: .ValueChanged)
	}
	
	func handleStepper(sender: AnyObject?) {
		self.testStep.number = Int(self.numberStepper.value)
		self.numberValueLbl.text = "\(self.testStep.number)"
	}
	
	func done(sender: AnyObject?) {
		if !self.textField.text.isEmpty {
			self.testStep.text = self.textField.text
			UIApplication.sharedApplication().networkActivityIndicatorVisible = true
			ObjectManager.createTestStep(testStep, completionBlock: { [unowned self] (result, error) -> Void in
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					UIApplication.sharedApplication().networkActivityIndicatorVisible = false
					ErrorHandler.handleError(error)
					if error == nil {
						self.navigationController?.popViewControllerAnimated(true)
						self.callback?(self.testStep)
					}
					// TODO: handle error
				});
			})
		} else {
			// TODO: handle error
		}
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
