//
//  TestCaseViewController.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class TestCaseViewController: UIViewController {

	@IBOutlet var titleHintLbl: UILabel!
	@IBOutlet var titleField: UITextField!
	
	var project: Project?
	var callback: ((TestCase!) -> Void)?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = NSLocalizedString("layouts.testcase.add.title", comment: "add testcase view title")
		
		let doneBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
		self.navigationItem.rightBarButtonItem = doneBtn
		
		self.titleHintLbl.text = NSLocalizedString("layouts.testcase.add.name.hint", comment: "testcase name hint lable title")
		self.titleField.placeholder = NSLocalizedString("layouts.testcase.add.name.field.placeholder", comment: "testcase name field placeholder")
    }
	
	func done(sender: AnyObject?) {
		if !self.titleField.text!.isEmpty {
			let testCase = TestCase()
			testCase.title = self.titleField.text
			testCase.project = self.project
			UIApplication.sharedApplication().networkActivityIndicatorVisible = true
			ObjectManager.createTestCase(testCase, completionBlock: { [unowned self] (result, error) -> Void in
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					UIApplication.sharedApplication().networkActivityIndicatorVisible = false
					ErrorHandler.handleError(error)
					if error == nil {
						self.navigationController?.popViewControllerAnimated(true)
						self.callback?(testCase)
					}
					// TODO: handle error
				});
			})
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
