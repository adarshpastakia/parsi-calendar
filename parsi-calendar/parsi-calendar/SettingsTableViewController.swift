//
//  SettingsTableViewController.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/13/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var swLanguage:UISwitch!
    @IBOutlet var ivIcon:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        swLanguage.on = (Statics.userDefaults.stringForKey("language") == "gj")
        
        ivIcon.layer.borderWidth = 0.5
        ivIcon.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 && indexPath.row == 0 {
			cell.detailTextLabel?.text = BundleFields.versionString
		}
	}
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
	

	// #pragma mark - Actions
	@IBAction func dismiss(sender:AnyObject!) {
		dismissViewControllerAnimated(true, completion: nil)
	}
    
    @IBAction func changeLanguage(sender:AnyObject!) {
        Statics.userDefaults.setValue(((sender as UISwitch).on ? "gj" : "en"), forKey: "language")
        Statics.userDefaults.synchronize()
    }
}
