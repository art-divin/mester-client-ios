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
		var headerBtn = UIButton()
		headerBtn.setTitleColor(ThemeDefault.colorForButtonTitle(.Active), forState: .Normal)
		headerBtn.setTitleColor(ThemeDefault.colorForButtonTitle(.Selected), forState: .Highlighted)
		headerBtn.backgroundColor = UIColor.clearColor()
		if self.test?.startDate == nil {
			headerBtn.addTarget(self, action: "startTest", forControlEvents: .TouchUpInside)
			headerBtn.setTitle(NSLocalizedString("layouts.casetest.header.button.start.title", comment: "start test button title"), forState: .Normal)
		} else {
			headerBtn.addTarget(self, action: "submitTest", forControlEvents: .TouchUpInside)
			headerBtn.setTitle(NSLocalizedString("layouts.casetest.header.button.submit.title", comment: "submit test button title"), forState: .Normal)
		}
		let screenWidth = CGRectGetWidth(self.view.bounds)
		var headerView = UIView(frame: CGRectMake(0, 0, screenWidth, 50.0))
		headerView.backgroundColor = ThemeDefault.colorForButtonBg(.Active)
		headerView.addSubview(headerBtn)
		headerBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
		headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[headerBtn]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "headerBtn" : headerBtn ]))
		headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[headerBtn(==44)]", options: NSLayoutFormatOptions(0), metrics: nil, views: [ "headerBtn" : headerBtn ]))
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
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
		let caseTest = self.objects[indexPath.row]
		cell.textLabel!.text = caseTest.testCase?.title
		// TODO: localization
		cell.detailTextLabel!.text = "status: \(caseTest.status.rawValue)"
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
			// TODO:
			
		} else if editingStyle == .Insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
	
}
