//
//  TestsViewController.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 17/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class TestsViewController: UITableViewController {
	
	var objects: [AnyObject] = []
	var testsShown = false
	var segmentCtrl: UISegmentedControl?
	
	var project: Project? {
		didSet {
			// Update the view.
			self.configureView()
		}
	}
	
	func fetchTests() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
		ObjectManager.fetchTests(project) { [weak self] (result, error) in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				ErrorHandler.handleError(error);
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
				if error == nil {
					self?.objects.removeAll(keepCapacity: false)
					self?.objects.extend(result as [AnyObject]!)
					self?.testsShown = true
					self?.tableView.reloadData()
				}
			});
		}
	}
	
	func fetchTestCases() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
		ObjectManager.fetchTestCases(project) { [weak self] (result, error) in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				ErrorHandler.handleError(error);
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
				if error == nil {
					self?.objects.removeAll(keepCapacity: false)
					self?.objects.extend(result as [AnyObject]!)
					self?.testsShown = false
					self?.tableView.reloadData()
				}
			});
		}
	}
	
	func createTest(testCase: TestCase!) {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
		ObjectManager.createTest(project) { [weak self] (result, error) in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				ErrorHandler.handleError(error);
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
				if error == nil {
					self?.segmentCtrl?.selectedSegmentIndex = 1;
					self?.segmentControlTapped(nil)
				}
			});
		}
	}
	
	func configureView() {
		// Update the user interface for the detail item.
		if self.project != nil {
			if !self.testsShown {
				self.fetchTestCases()
			} else {
				self.fetchTests()
			}
		}
		self.navigationItem.title = self.project?.name
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showTestCaseDetails:")
		self.navigationItem.rightBarButtonItem = addButton
		self.segmentCtrl = UISegmentedControl(items: [NSLocalizedString("layouts.tests.segment.cases.title", comment: "test cases segment item"), NSLocalizedString("layouts.tests.segment.tests.title", comment: "case test segment item")])
		segmentCtrl?.selectedSegmentIndex = 0
		segmentCtrl?.addTarget(self, action: "segmentControlTapped:", forControlEvents: .ValueChanged)
		self.tableView.tableHeaderView = segmentCtrl
	}
	
	func segmentControlTapped(sender: AnyObject?) {
		switch ((self.segmentCtrl as UISegmentedControl?)!.selectedSegmentIndex) {
		case 0: self.testsShown = false
		case 1: self.testsShown = true
		default: break
		}
		if self.project != nil {
			self.objects = []
			self.tableView.reloadData()
			if !self.testsShown {
				let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showTestCaseDetails:")
				self.navigationItem.rightBarButtonItem = addButton
				self.fetchTestCases()
			} else {
				self.navigationItem.rightBarButtonItem = nil
				self.fetchTests()
			}
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		configureView()
	}
	
	func showTestCaseDetails(sender: AnyObject?) {
		var testCaseVC = self.storyboard?.instantiateViewControllerWithIdentifier("TestCaseViewController") as TestCaseViewController
		testCaseVC.project = self.project
		testCaseVC.callback = { [unowned self] (testCase) -> Void in
			self.fetchTestCases()
		}
		self.navigationController?.pushViewController(testCaseVC, animated: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "StepsViewController" {
			if let indexPath = self.tableView.indexPathForSelectedRow() {
				let testCase: TestCase = objects[indexPath.row] as TestCase
				(segue.destinationViewController as StepsViewController).testCase = testCase
			}
		}
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
		if identifier == "StepsViewController" {
			if self.testsShown {
				if let indexPath = self.tableView.indexPathForSelectedRow() {
					let test: Test = objects[indexPath.row] as Test
					var caseTestVC = self.storyboard?.instantiateViewControllerWithIdentifier("CaseTestViewController") as CaseTestViewController
					caseTestVC.test = test
					self.navigationController?.pushViewController(caseTestVC, animated: true)
					self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
				}
			}
			return !self.testsShown as Bool
		}
		return true
	}
	
	// MARK: - Table View
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TestCaseCell
		var dateFormatter = Common.dateFormatter
		dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
		if !self.testsShown {
			let testCase: TestCase = objects[indexPath.row] as TestCase
			cell.textLabel!.text = testCase.title
			cell.detailTextLabel!.text = dateFormatter.stringFromDate(testCase.creationDate)
			cell.button.setTitle(NSLocalizedString("layouts.testcase.cell.button.testcase.title", comment: "start test button title"), forState: .Normal)
			cell.object = testCase
			cell.callback = { [weak self] object in
				var testCase = object as TestCase
				self?.createTest(testCase)
			}
		} else {
			var test: Test = objects[indexPath.row] as Test
			// TODO: localization
			cell.textLabel!.text = "created: \(dateFormatter.stringFromDate(test.creationDate))"
			var detailStr = "status: \(test.status.rawValue)"
			if test.startDate != nil && test.endDate == nil {
				detailStr += "; started: \(dateFormatter.stringFromDate(test.startDate!))"
			} else if test.endDate != nil {
				detailStr += "; finished: \(dateFormatter.stringFromDate(test.startDate!))"
			}
			cell.detailTextLabel!.text = detailStr
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return ThemeDefault.heightForCell()
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			if !self.testsShown {
				let testCase = objects[indexPath.row] as TestCase
				UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
				ObjectManager.deleteTestCase(testCase, completionBlock: { [unowned self] (result, error) -> Void in
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						ErrorHandler.handleError(error)
						UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
						if error == nil {
							self.objects.removeAtIndex(indexPath.row)
							self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
						}
					});
				})
			} else {
				let test = objects[indexPath.row] as Test
				// TODO:
			}
			
		} else if editingStyle == .Insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
	
}

