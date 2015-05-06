//
//  SettingsTableViewController.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/13/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit
import StoreKit
import CloudKit

class SettingsTableViewController: UITableViewController {
    
    var unlocked = true
    var cells = [["AboutCell"], ["LanguageCell"], ["BookmarksCell", "CalendarEnableCell"], ["SyncNowCell"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //swLanguage.on = (Statics.userDefaults.stringForKey("language") == "gu")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.detailTextLabel?.text = BundleFields.versionString
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !unlocked && indexPath.section == 2 {
            return tableView.dequeueReusableCellWithIdentifier("InAppCell", forIndexPath: indexPath) as UITableViewCell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cells[indexPath.section][indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.section == 2 && indexPath.row == 1 {
            (cell.contentView.viewWithTag(1) as UISwitch).on = (Statics.userDefaults!.boolForKey("add2calendar"))
        }
        if indexPath.section == 1 {
            (cell.contentView.viewWithTag(1) as UISwitch).on = (Statics.userDefaults!.stringForKey("language") == "gu")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 2
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 {
            return "iCloud Sync"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return "Enable add to calendar to add bookmark day entries to your calendar"
        }
        if section == 3 {
            return "Sync bookmarked days with multiple devices using your iCloud account"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            
        }
        if indexPath.section == 3 && indexPath.row == 2 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            Helper.showAlert("Sync Now", msg: NSDate().formatted("dd MMM yyyy"), viewController: self)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    // MARK: - Actions
    @IBAction func dismiss(sender:AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeLanguage(sender:AnyObject!) {
        Statics.userDefaults!.setValue(((sender as UISwitch).on ? "gu" : "en"), forKey: "language")
        Statics.userDefaults!.synchronize()
    }
    
    @IBAction func toggleAdd2Calendar(sender:AnyObject!) {
        Statics.userDefaults!.setBool((sender as UISwitch).on, forKey: "add2calendar")
        Statics.userDefaults!.synchronize()
        
        NSNotificationCenter.defaultCenter().postNotificationName("Add2Calendar", object: (sender as UISwitch).on)
    }
    
    @IBAction func syncNow(sender:AnyObject!) {
        BookmarkDay.icloudSync()
    }
}
