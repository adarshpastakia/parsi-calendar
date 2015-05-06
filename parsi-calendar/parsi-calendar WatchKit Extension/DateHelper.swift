//
//  DateHelper.swift
//  personalbook
//
//  Created by Adarsh Pastakia on 6/19/14.
//  Copyright (c) 2014 Adarsh Pastakia. All rights reserved.
//

import UIKit

extension NSDate {
	
	func formatted(format:String) -> String {
		let df = NSDateFormatter()
		df.dateFormat = format
		return df.stringFromDate(self)
	}
	
	func before(date:NSDate) -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal?.compareDate(self, toDate: date, toUnitGranularity: .CalendarUnitDay) == NSComparisonResult.OrderedAscending
	}
	func after(date:NSDate) -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal?.compareDate(self, toDate: date, toUnitGranularity: .CalendarUnitDay) == NSComparisonResult.OrderedDescending
	}
	
	func isToday() -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal?.compareDate(self, toDate: NSDate(), toUnitGranularity: .CalendarUnitDay) == NSComparisonResult.OrderedSame
	}
	
	func onOrBefore(date:NSDate) -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal?.compareDate(self, toDate: date, toUnitGranularity: .CalendarUnitDay) != NSComparisonResult.OrderedDescending
	}
	func onOrAfter(date:NSDate) -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal?.compareDate(self, toDate: date, toUnitGranularity: .CalendarUnitDay) != NSComparisonResult.OrderedAscending
    }
    
    func clearTime() -> NSDate {
        let comp = self.components()
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        return NSDate.fromComponents(comp)
    }
    
    func add(days count:Int) -> NSDate {
        let comp = self.components()
        comp.day += count
        return NSDate.fromComponents(comp)
    }
    
    func add(months count:Int) -> NSDate {
        let comp = self.components()
        comp.month += count
        return NSDate.fromComponents(comp)
    }
    
    func daysSince(date:NSDate) -> Int {
        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var st1:NSDate?, en1:NSDate?
        
        let stComp = date.components()
        let enComp = self.components()
        
        let st = NSDate.fromComponents(stComp.day, month: stComp.month, year: stComp.year)
        let en = NSDate.fromComponents(enComp.day, month: enComp.month, year: enComp.year)
        
        //NSLog("Start: %@, End: %@", st, en)
        cal?.rangeOfUnit(.CalendarUnitDay, startDate: &st1, interval: nil, forDate: st)
        cal?.rangeOfUnit(.CalendarUnitDay, startDate: &en1, interval: nil, forDate: en)
        //NSLog("Start1: %@, End1: %@", st1!, en1!)
        let startDay=cal?.ordinalityOfUnit(.CalendarUnitDay, inUnit: .EraCalendarUnit, forDate: st1!)
        let endDay=cal?.ordinalityOfUnit(.CalendarUnitDay, inUnit: .EraCalendarUnit, forDate: en1!)
        return endDay!-startDay!
    }

	
	func components() -> NSDateComponents! {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal?.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: self);
	}
	
	class func fromComponents(components:NSDateComponents) -> NSDate! {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal?.dateFromComponents(components)
	}
	
	class func fromComponents(day:Int, month:Int, year:Int) -> NSDate! {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		
		var components = NSDate().components()!
		
		components.day = day
		components.month = month
        components.year = year
        components.hour = 0
        components.minute = 0
        components.second = 0
		
		return cal?.dateFromComponents(components)
		
	}
}
