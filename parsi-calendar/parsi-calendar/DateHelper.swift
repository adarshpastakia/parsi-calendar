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
		return cal.compareDate(self, toDate: date, toUnitGranularity: .CalendarUnitDay) == NSComparisonResult.OrderedAscending
	}
	func after(date:NSDate) -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal.compareDate(self, toDate: date, toUnitGranularity: .CalendarUnitDay) == NSComparisonResult.OrderedDescending
	}
	
	func isToday() -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal.compareDate(self, toDate: NSDate(), toUnitGranularity: .CalendarUnitDay) == NSComparisonResult.OrderedSame
	}
	func on(date:NSDate) -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal.compareDate(self, toDate: date, toUnitGranularity: .CalendarUnitDay) == NSComparisonResult.OrderedSame
	}
	
	func onOrBefore(date:NSDate) -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal.compareDate(self, toDate: date, toUnitGranularity: .CalendarUnitDay) != NSComparisonResult.OrderedDescending
	}
	func onOrAfter(date:NSDate) -> Bool {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal.compareDate(self, toDate: date, toUnitGranularity: .CalendarUnitDay) != NSComparisonResult.OrderedAscending
	}
	
	class func hourInterval(hrs:CDouble) -> CDouble {
		return hrs * 60 * 60 * 1000
	}
	class func dayInterval(days:CDouble) -> CDouble {
		return days * 24 * 60 * 60 * 1000
	}
	
	func components() -> NSDateComponents {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		return cal.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: self);
	}
	
	class func fromComponents(components:NSDateComponents) -> NSDate {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		cal.timeZone = NSTimeZone(abbreviation: "GMT")
		return cal.dateFromComponents(components)!
	}
	
	class func fromComponents(day:Int, month:Int, year:Int) -> NSDate {
		let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		cal.timeZone = NSTimeZone(abbreviation: "GMT")
		
		var components = NSDate().components()
		
		components.day = day
		components.month = month
		components.year = year
		
		return cal.dateFromComponents(components)!
		
	}
}
