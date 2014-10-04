//
//  SettingsTableViewController.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/13/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var unlocked = true
    var cells = [["AboutCell"], ["LanguageCell"], ["BookmarksCell", "NotificationCell"]]
    
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
        if !unlocked {
            return tableView.dequeueReusableCellWithIdentifier("InAppCell", forIndexPath: indexPath) as UITableViewCell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cells[indexPath.section][indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.section == 1 {
            (cell.contentView.viewWithTag(1) as UISwitch).on = (Statics.userDefaults.stringForKey("language") == "gu")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return unlocked ? 2 : 1
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 && !unlocked {
            return "Unlock full-version to add personal bookmarks"
        }
        return nil
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // MARK: - Actions
    @IBAction func dismiss(sender:AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeLanguage(sender:AnyObject!) {
        Statics.userDefaults.setValue(((sender as UISwitch).on ? "gu" : "en"), forKey: "language")
        Statics.userDefaults.synchronize()
    }
}
