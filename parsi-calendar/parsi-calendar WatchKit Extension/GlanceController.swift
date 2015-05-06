//
//  GlanceController.swift
//  parsi-calendar WatchKit Extension
//
//  Created by Adarsh Pastakia on 11/02/2015.
//  Copyright (c) 2015 Boris Inc. All rights reserved.
//

import WatchKit
import Foundation

class GlanceController: WKInterfaceController {
    @IBOutlet var lbGregDay:WKInterfaceLabel!
    @IBOutlet var lbGregDate:WKInterfaceLabel!
    
    @IBOutlet var lbDay:WKInterfaceLabel!
    @IBOutlet var lbMonth:WKInterfaceLabel!
    
    @IBOutlet var gpParsiDay:WKInterfaceGroup!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        lbGregDay.setText(NSDate().formatted("EEEE"))
        lbGregDate.setText(NSDate().formatted("dd MMM"))
        
        var day = WkCalendar.getParsiDay(NSDate())
        var month = WkCalendar.getParsiMonth(NSDate())
        
        lbDay.setText("\(WkDayNames.name(day))")
        lbMonth.setText("\(WkMonthNames.name(month))")
        
        gpParsiDay.setBackgroundColor(UIColor(white: 1.0, alpha: 0.0))
        if contains(WkDates.impDays, day) {
            gpParsiDay.setBackgroundColor(WkColors.importantDay)
        }
        if day >= 30 {
            gpParsiDay.setBackgroundColor(WkColors.gathaDay)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
