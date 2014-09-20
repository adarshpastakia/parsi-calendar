//
//  Calendar.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/11/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

enum WdMonthNames {
    static var en = ["FRAVARDIN","ARDIBEHESHT","KHORDAD","TIR","AMARDAD","SHEHREVAR","MEHER","AVAN","ADAR","DAE","BAHMAN","ASPANDARD"]
    static var gj = ["ષરાવારદિન","આરદિભેસથ","કહોરદાદ","તીર","અમરદાદ","સહેહરેવાર","મેહેર","આવન","આદર","દે","બાહમાન","અસપાનદારદ"]
    
    static func name(index:Int) -> String {
        if NSUserDefaults(suiteName: "com.borisinc.ParsiCalendar").stringForKey("language") == "gj" {
            return "માહ: " + WdMonthNames.gj[index]
        }
        return "Mah: " + WdMonthNames.en[index];
    }
}

enum WdDayNames {
    static var en = ["Hormazd","Bahman","Ardibehesht","Shehrevar","Aspandard","Khordad","Amardad","Dae-pa-Adar","Adar","Avan","Khorshed","Meher","Tir","Gosh","Dae-pa-Meher","Meher","Srosh","Rashne","Fravardin","Behram","Ram","Govad","Dae-pa-Din","Din","Ashishvangh","Ashtad","Asman","Zamyad","Mareshpand","Aneran","Ahunavaiti","Ushtavaiti","Spentamainyu","Vohuxshathra","Vahishtoishti"]
    static var gj = ["હોરમઙદ","બહમન","આરદિભેસથ","સહેહરેવાર","આઅસપાનદારદ","કહોરદાદ","અમરદાદ","દે-પા-દાર","આદર","આવન","ખોરશેદ","મેહેર","તીર","ગોશ","દે-પા-દાર","મેહેર","સરોશ","રાશને","ષરાવારદિન","બેહરામ","રામ","ગોવાદ","દે-પા-દીન","દીન","આશિશવાનઘ","આશતાદ","આસમાન","ઙમયાદ","મારેસપાનદ","અનેરાન","અહુનાવઉતિ","ઇશતાવઉતિ","સપેનતામઉનયુ","વોહુષસહાતરા","વાહિસહતોિસહતિ"]
    
    static func name(index:Int) -> String {
        if NSUserDefaults(suiteName: "com.borisinc.ParsiCalendar").stringForKey("language") == "gj" {
            return "રોજ: " + WdDayNames.gj[index]
        }
        return "Roj: " + WdDayNames.en[index]
    }
}

enum WdDates {
	static let pYear:CInt = 1383
	static let gregDate = NSDate.fromComponents(18, month:8, year:2013)
	
	static let impDays = [0,2,8,16,18,19]
}

enum WdColors {
	static var weekendColor:UIColor {
	return UIColor(hue:150.0/360.0, saturation:0.7, brightness:0.4, alpha:1.0)
		//return UIColor(hue:210.0/360.0, saturation:1.0, brightness:0.5, alpha:1.0)
	}
	
	static var importantDay:UIColor {
	return UIColor(hue:1.0, saturation:1.0, brightness:0.9, alpha:0.5)
	}
	
	static var gathaDay:UIColor {
	return UIColor(hue:150.0/360.0, saturation:1.0, brightness:0.5, alpha:0.5)
	}
	
	static var today:UIColor {
	return UIColor(hue:90.0/360.0, saturation:0.9, brightness:0.6, alpha:0.1)
	}
	
	static var todayBorder:UIColor {
	return UIColor(hue:90.0/360.0, saturation:0.9, brightness:0.6, alpha:0.5)
	}
	
}

class WdCalendar: NSObject {
	
	class func getParsiYear(date:NSDate) -> CInt {
		let ti = date.timeIntervalSinceDate(WdDates.gregDate)
		var diff:NSNumber = 0
		
		if ti > 0 {
			diff = floor((ti / (24*60*60))/365)
		}
		else {
			diff = ceil((ti / (24*60*60))/365)
		}
		return WdDates.pYear + diff.intValue
	}
	
	class func getParsiMonth(date:NSDate)  -> Int {
		let ti = date.timeIntervalSinceDate(WdDates.gregDate)
		
		var diff:NSNumber = 0
		var day:NSNumber = 0
		
		if ti > 0 {
			day = floor((ti / (24*60*60))) % 365
			diff = floor((floor((ti / (24*60*60))) % 365) / 30.0)
		}
		else {
			day = ceil((ti / (24*60*60))) % 365
			diff = ceil((ceil((ti / (24*60*60))) % 365) / 30.0)
		}
		
		if abs(day.integerValue) >= 360 {
			return 11
		}
		
		return abs(diff.integerValue)
	}
	
	
	class func getParsiDay(date:NSDate)  -> Int {
		let ti = date.timeIntervalSinceDate(WdDates.gregDate)
		
		var diff:NSNumber = 0
		var day:NSNumber = 0
		
		if ti > 0 {
			day = floor((ti / (24*60*60))) % 365
			diff = floor((floor((ti / (24*60*60))) % 365) % 30.0)
		}
		else {
			day = ceil((ti / (24*60*60))) % 365
			diff = ceil((ceil((ti / (24*60*60))) % 365) % 30.0)
		}
		
		if abs(day.integerValue) >= 360 {
			return 30 + (abs(day.integerValue) % 360)
		}
		
		return abs(diff.integerValue)
	}
}
