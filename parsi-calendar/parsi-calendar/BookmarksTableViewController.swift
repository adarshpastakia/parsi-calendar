//
//  BookmarksTableViewController.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/13/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit
import CoreData

class BookmarksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	let CellIdentifier = "BookmarkCell"
	
	var managedObjectContext = Statics.appDelegate.managedObjectContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.editing = true
	}
	
	
	override func viewDidAppear(animated: Bool) {
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// #pragma mark - Table view data source
	// #pragma mark - Table view data source
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections!.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
		return section == 0 ? sectionInfo.numberOfObjects + 1 : sectionInfo.numberOfObjects
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		tableView.scrollEnabled = true
		
		let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell
		//self.configureCell(cell, atIndexPath: indexPath)
		if indexPath.section == 0 && indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1 {
			cell.textLabel?.text = "Jamshedji Navroz"
			cell.detailTextLabel?.text = "21st - March"
		}
		else if let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as? BookmarkDay {
			cell.textLabel?.text = object.bookmarkTitle
			cell.detailTextLabel?.text = "\(DayNames.en[object.day.integerValue]) - \(MonthNames.en[object.month.integerValue])"
		}
		
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return indexPath.section == 1
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			let context = self.fetchedResultsController.managedObjectContext
			context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as BookmarkDay)
			
			var error: NSError? = nil
			if !context.save(&error) {
				// Replace this implementation with code to handle the error appropriately.
				// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				//println("Unresolved error \(error), \(error.userInfo)")
				abort()
			}
		}
	}
	
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return section == 0 ? "Default Bookmarks" : "Configured Bookmarks"
	}
	
	// #pragma mark - Fetched results controller
	var fetchedResultsController: NSFetchedResultsController {
	if _fetchedResultsController != nil {
		return _fetchedResultsController!
		}
		
		let fetchRequest = NSFetchRequest()
		// Edit the entity name as appropriate.
		let entity = NSEntityDescription.entityForName("Bookmarks", inManagedObjectContext: self.managedObjectContext!)
		fetchRequest.entity = entity
		
		// Set the batch size to a suitable number.
		fetchRequest.fetchBatchSize = 20
		
		// Edit the sort key as appropriate.
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isDefault", ascending: false), NSSortDescriptor(key: "month", ascending: true), NSSortDescriptor(key: "day", ascending: true)]
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "isDefault", cacheName: "Bookmarks")
		aFetchedResultsController.delegate = self
		_fetchedResultsController = aFetchedResultsController
		NSFetchedResultsController.deleteCacheWithName("Bookmarks")
		
		var error: NSError? = nil
		if !_fetchedResultsController!.performFetch(&error) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			//println("Unresolved error \(error), \(error.userInfo)")
			abort()
		}
		
		return _fetchedResultsController!
	}
	var _fetchedResultsController: NSFetchedResultsController? = nil
	
	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		self.tableView.beginUpdates()
	}
	
	func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
		switch type {
		case NSFetchedResultsChangeType.Insert:
			self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
		case NSFetchedResultsChangeType.Delete:
			self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
		default:
			return
		}
	}
	
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
		switch type {
		case NSFetchedResultsChangeType.Insert:
			tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
		case NSFetchedResultsChangeType.Delete:
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			//case NSFetchedResultsChangeUpdate:
			//self.configureCell(tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell, atIndexPath: indexPath)
		case NSFetchedResultsChangeType.Move:
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
		default:
			return
		}
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		self.tableView.endUpdates()
	}
	
}
