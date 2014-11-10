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
    var defaultSection = 0
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
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0;
        let realNumberOfSections = self.fetchedResultsController.sections!.count
        if realNumberOfSections == 1 {
            defaultSection = 0
            if section == 0 {
                count = 1
            }
            else if section == 1 {
                let sectionInfo = self.fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
                count = sectionInfo.numberOfObjects
            }
        }
        else {
            defaultSection = 1
            let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
            count = sectionInfo.numberOfObjects
        }
        
        return count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.scrollEnabled = true
        
        if indexPath.section == 0 && self.fetchedResultsController.sections!.count == 1 {
            return tableView.dequeueReusableCellWithIdentifier("NoData", forIndexPath: indexPath) as UITableViewCell
        }
        
        var newPath = indexPath
        if indexPath.section == 1 && self.fetchedResultsController.sections!.count == 1 {
            newPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell
        //self.configureCell(cell, atIndexPath: indexPath)
        if indexPath.section == 1 && indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1 {
            cell.textLabel.text = Calendar.bookmarkLabel("Jamshedji Navroz")
            cell.detailTextLabel?.text = "21st - March"
        }
        else if let object = self.fetchedResultsController.objectAtIndexPath(newPath) as? BookmarkDay {
            cell.textLabel.text =  Calendar.bookmarkLabel(object.bookmarkTitle)
            cell.detailTextLabel?.text = "\(DayNames.name(object.day.integerValue)) - \(MonthNames.name(object.month.integerValue))"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return indexPath.section == 0 && self.fetchedResultsController.sections!.count == 2
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
        return section == 1 ? "Default Bookmarks" : "Personal Bookmarks"
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as UITableViewHeaderFooterView).contentView.backgroundColor = UIColor(hue:139.0/360.0, saturation:0.02, brightness:0.96, alpha:1.0)
    }
    
    // MARK: - Fetched results controller
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
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isDefault", ascending: true), NSSortDescriptor(key: "month", ascending: true), NSSortDescriptor(key: "day", ascending: true)]
            
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
        //case NSFetchedResultsChangeType.Insert:
            //self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        //case NSFetchedResultsChangeType.Delete:
            //self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            if defaultSection == 0 {
                tableView.deleteRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                tableView.reloadData()
            }
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if self.fetchedResultsController.sections!.count == 1 {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.reloadData()
            }
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
