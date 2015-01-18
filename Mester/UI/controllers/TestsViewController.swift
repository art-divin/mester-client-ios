//
//  TestsViewController.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 17/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class TestsViewController: UITableViewController {
	
	var objects: [TestCase] = []
	
	var project: Project? {
		didSet {
			// Update the view.
			self.configureView()
		}
	}
	
	func configureView() {
		// Update the user interface for the detail item.
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
		if let project = self.project {
			ObjectManager.fetchTestCases(project) { [weak self] (result, error) in
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					ErrorHandler.handleError(error);
					UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
					self?.objects.removeAll(keepCapacity: false)
					self?.objects.extend(result as [TestCase])
					self?.tableView.reloadData()
				});
			}
		}
		self.navigationItem.title = self.project?.name
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "StepsViewController" {
			if let indexPath = self.tableView.indexPathForSelectedRow() {
				let testCase = objects[indexPath.row]
				(segue.destinationViewController as StepsViewController).testCase = testCase
			}
		}
	}
	
	// MARK: - Table View
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
		
		let object = objects[indexPath.row]
		cell.textLabel!.text = object.title
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return false
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			objects.removeAtIndex(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		} else if editingStyle == .Insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
	
}

