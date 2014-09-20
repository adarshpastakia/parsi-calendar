//
//  TodayViewController.swift
//  parsi-calendar-widget
//
//  Created by Adarsh Pastakia on 7/11/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
    
    @IBOutlet var lbDate:UILabel!
    @IBOutlet var lbTomorrow:UILabel!
    @IBOutlet var ivDate:UIImageView!
    @IBOutlet var ivTomorrow:UIImageView!
    
    override init() {
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("Widget Loaded")
        // Do any additional setup after loading the view from its nib.
        
        var day = WdCalendar.getParsiDay(NSDate())
        var month = WdCalendar.getParsiMonth(NSDate())
        
        lbDate.text = "\(WdDayNames.name(day))\n\(WdMonthNames.name(month))"
        
        ivDate.backgroundColor = UIColor.lightTextColor()
        ivTomorrow.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.75)
        if contains(WdDates.impDays, day) {
            lbDate.textColor = UIColor.whiteColor()
            ivDate.backgroundColor = WdColors.importantDay
        }
        if day >= 30 {
            lbDate.textColor = UIColor.whiteColor()
            ivDate.backgroundColor = WdColors.gathaDay
        }
        
        var nday = WdCalendar.getParsiDay(NSDate(timeIntervalSinceNow: 24*60*60))
        var nmonth = WdCalendar.getParsiMonth(NSDate(timeIntervalSinceNow: 24*60*60))
        
        lbTomorrow.text = "Tomorrow\n\(WdDayNames.name(nday))\n\(WdMonthNames.name(nmonth))"
        
        if contains(WdDates.impDays, nday) {
            lbTomorrow.textColor = UIColor.whiteColor()
            ivTomorrow.backgroundColor = WdColors.importantDay
        }
        if nday >= 30 {
            lbTomorrow.textColor = UIColor.whiteColor()
            ivTomorrow.backgroundColor = WdColors.gathaDay
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
    
}
