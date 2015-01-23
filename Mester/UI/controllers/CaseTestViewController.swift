//
//  CaseTestViewController.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 22/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class CaseTestViewController: UITableViewController {
	
	var objects: [CaseTest] = []
	var test: Test? {
		didSet {
			if let test = self.test {
				self.objects = test.caseTests
				self.setupHeaderView()
				self.tableView.reloadData()
			}
		}
	}
	
	func startTest() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
		ObjectManager.startTest(self.test) { [weak self] (result, error) in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				ErrorHandler.handleError(error);
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
				if error == nil {
					self?.test = result as Test?
				}
			});
		}
	}
	
	func submitTest() {
		if self.test?.startDate != nil {
			UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
			ObjectManager.submitTest(self.test) { [weak self] (result, error) in
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					ErrorHandler.handleError(error);
					UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
					if error == nil {
						self?.test = result as Test?
					}
				});
			}
		}
	}
	
	func setupHeaderView() {
		var startBtn = UIButton()
		var submitBtn = UIButton()
		startBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
		submitBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
		startBtn.backgroundColor = UIColor.greenColor()
		submitBtn.backgroundColor = UIColor.yellowColor()
		startBtn.addTarget(self, action: "startTest", forControlEvents: .TouchUpInside)
		submitBtn.addTarget(self, action: "submitTest", forControlEvents: .TouchUpInside)
		startBtn.setTitle(NSLocalizedString("layouts.casetest.header.button.start.title", comment: "start test button title"), forState: .Normal)
		submitBtn.setTitle(NSLocalizedString("layouts.casetest.header.button.submit.title", comment: "submit test button title"), forState: .Normal)
		let screenWidth = CGRectGetWidth(self.view.bounds)
		var headerView = UIView(frame: CGRectMake(0, 0, screenWidth, 50.0))
		headerView.addSubview(startBtn)
		headerView.addSubview(submitBtn)
		startBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
		submitBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
		headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[startBtn(==100)]-(>=50)-[submitBtn(==100)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "startBtn" : startBtn, "submitBtn" : submitBtn ]))
		headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[startBtn(==44)]", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "startBtn" : startBtn ]))
		headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[submitBtn(==44)]", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "submitBtn" : submitBtn ]))
		self.tableView.tableHeaderView = headerView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "StepsViewController" {
			if let indexPath = self.tableView.indexPathForSelectedRow() {
				let caseTest: CaseTest = objects[indexPath.row] as CaseTest
				(segue.destinationViewController as StepsViewController).caseTest = caseTest
			}
		}
	}
	
	// MARK: - Table view data source
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.objects.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
		let caseTest = self.objects[indexPath.row]
		cell.textLabel!.text = caseTest.testCase?.title
		// TODO: localization
		cell.detailTextLabel!.text = "status: \(caseTest.status.rawValue)"
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			// TODO:
			
		} else if editingStyle == .Insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
	
}
