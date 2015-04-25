//
//  StepsViewController.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class StepsViewController: UITableViewController {
	
	var objects: [AnyObject] = []
	var test: Test? {
		didSet {
			if let test = test {
				self.setupHeaderView()
			}
		}
	}
	
	var testCase: TestCase? {
		didSet {
			if let testCase = testCase {
				self.objects.removeAll(keepCapacity: false)
				self.objects.extend(testCase.steps as [AnyObject]!)
				self.configureView()
				self.tableView.reloadData()
			}
		}
	}
	
	var caseTest: CaseTest? {
		didSet {
			if let caseTest = caseTest {
				self.objects.removeAll(keepCapacity: false)
				self.objects.extend(caseTest.stepTests as [AnyObject]!)
				self.tableView.reloadData()
			}
		}
	}
	
	func configureView() {
		if self.testCase != nil {
			self.navigationItem.title = NSLocalizedString("layouts.teststep.list.title", comment: "test step list view title")
			let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showTestStepDetails:")
			self.navigationItem.rightBarButtonItem = addButton
		}
	}
	
	func submitTest() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
		ObjectManager.submitTest(self.test) { [weak self] (result, error) in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				ErrorHandler.handleError(error);
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
				self?.refreshControl?.endRefreshing()
				if error == nil {
					self?.test = result as! Test?
					self?.fetchCaseTest()
				}
			});
		}
	}
	
	func setupHeaderView() {
		var refresh: UIRefreshControl = UIRefreshControl()
		var titleStr: NSAttributedString? = nil
		refresh.addTarget(self, action: "submitTest", forControlEvents: .ValueChanged)
		let str = NSLocalizedString("layouts.casetest.header.button.submit.title", comment: "submit test button title")
		titleStr = NSAttributedString(string: str, attributes: [ NSForegroundColorAttributeName : ThemeDefault.colorForButtonTitle(.Active) ])
		refresh.attributedTitle = titleStr
		refresh.tintColor = ThemeDefault.colorForTint()
		self.refreshControl = refresh
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.separatorStyle = .None
	}
	
	func fetchCaseTest() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
		ObjectManager.fetchCaseTest(self.caseTest) { [weak self] (result, error) in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				ErrorHandler.handleError(error);
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
				if error == nil {
					self?.caseTest = result as? CaseTest
					self?.test?.updateCaseTest(self?.caseTest)
				}
			});
		}
	}
	
	func fetchTestCases() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
		ObjectManager.fetchTestSteps(self.testCase) { [weak self] (result, error) in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				ErrorHandler.handleError(error);
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
				if error == nil {
					self?.objects.removeAll(keepCapacity: false)
					self?.objects.extend(result as [AnyObject]!)
					self?.tableView.reloadData()
				}
			});
		}
	}
	
	func showTestStepDetails(sender: AnyObject?) {
		var stepVC = self.storyboard?.instantiateViewControllerWithIdentifier("TestStepViewController") as! TestStepViewController
		stepVC.testCase = self.testCase
		stepVC.callback = { [unowned self] testStep in
			self.fetchTestCases()
		}
		self.navigationController?.pushViewController(stepVC, animated: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table View
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! StepCell
		cell.selectionStyle = .None
		if self.testCase != nil {
			let object = objects[indexPath.row] as! TestStep
			cell.textLabel!.text = object.text
			cell.detailTextLabel!.text = ""
			cell.setButtonVisibility(false)
		} else {
			let object = objects[indexPath.row] as! StepTest
			cell.textLbl.text = object.testStep?.text
			cell.statusLbl.text = object.status.rawValue
			// TODO: localization
			//			cell.detailTextLabel!.text = "status: \(object.status.rawValue)"
			cell.buttonSucceed.setTitle("succeed", forState: .Normal)
			cell.buttonFail.setTitle("fail", forState: .Normal)
			
			cell.setButtonVisibility(true)
			cell.object = object
			cell.succeedCallback = { [weak self] (object) in
				var stepTest = object as! StepTest
				stepTest.status = TestStatus.Succeed
			}
			cell.failCallback = { [weak self] (object) in
				var stepTest = object as! StepTest
				stepTest.status = TestStatus.Failed
			}
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		// TODO: implement dynamic row height
		return ThemeDefault.heightForCell()
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return self.testCase != nil
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			if self.testCase != nil {
				let testStep = objects[indexPath.row] as! TestStep
				UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
				ObjectManager.deleteTestStep(testStep, completionBlock: { [unowned self] (result, error) -> Void in
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
						ErrorHandler.handleError(error)
						if error == nil {
							self.objects.removeAtIndex(indexPath.row)
							self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
							self.fetchTestCases()
						}
					})
					})
			}
		} else if editingStyle == .Insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
	
}
