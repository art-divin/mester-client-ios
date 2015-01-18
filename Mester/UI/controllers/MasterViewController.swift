//
//  MasterViewController.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 17/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
	
	var objects: [Project] = []
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem()
		self.navigationItem.title = NSLocalizedString("layouts.main.title", comment: "main view title")
		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showProjectDetails:")
		self.navigationItem.rightBarButtonItem = addButton
		self.fetchProjectList()
	}
	
	func fetchProjectList() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
		ObjectManager.fetchProjects({ [unowned self] (result, error) in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				ErrorHandler.handleError(error);
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
				if result != nil {
					self.objects.removeAll(keepCapacity: false)
					self.objects.extend(result as [Project])
					self.tableView.reloadData()
				}
			});
		});
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func showProjectDetails(sender: AnyObject) {
		var projectVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProjectViewController") as ProjectViewController
		projectVC.callback = { [unowned self] (project) in
			self.fetchProjectList()
		}
		self.navigationController?.pushViewController(projectVC, animated: true);
	}
	
	// MARK: - Segues
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
			if let indexPath = self.tableView.indexPathForSelectedRow() {
				let project = objects[indexPath.row] as Project
				(segue.destinationViewController as DetailViewController).project = project
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
		
		let object = objects[indexPath.row] as Project
		cell.textLabel!.text = object.name
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

