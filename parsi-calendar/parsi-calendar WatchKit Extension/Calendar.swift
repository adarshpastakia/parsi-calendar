//
//  Calendar.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/11/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

enum WkMonthNames {
    static var en = ["FRAVARDIN","ARDIBEHESHT","KHORDAD","TIR","AMARDAD","SHEHREVAR","MEHER","AVAN","ADAR","DAE","BAHMAN","ASPANDARD"]
    static var gu = ["ફરવદીન","અરદીબહેશ્ત","ખોરદાદ","તીર","અમરદાદ","શહેરેવર","મેહેર","આવાં","આદર","દઍ","બહમન","અસ્પંદાર્મદ"]
    
    static func name(index:Int) -> String {
        if NSUserDefaults(suiteName: "group.com.borisinc.ParsiCalendar")?.stringForKey("language") == "gu" {
            return "માહ: " + WkMonthNames.gu[index]
        }
        return "Mah: " + WkMonthNames.en[index];
    }
}

enum WkDayNames {
    static var en = ["Hormazd","Bahman","Ardibehesht","Shehrevar","Aspandard","Khordad","Amardad","Dae-pa-Adar","Adar","Avan","Khorshed","Mohor","Tir","Gosh","Dae-pa-Meher","Meher","Srosh","Rashne","Fravardin","Behram","Ram","Govad","Dae-pa-Din","Din","Ashishvangh","Ashtad","Asman","Zamyad","Mareshpand","Aneran","Ahunavaiti","Ushtavaiti","Spentamainyu","Vohuxshathra","Vahishtoishti"]
    static var gu = ["હોરમઝદ","બહમન","અરદીબહેશ્ત","શહેરેવર","અસ્પંદાર્મદ","ખોરદાદ","અમરદાદ","દેપઆદર","આદર","આવાં","ખોરશેદ","મોહોર","તીર","ગોશ","દએપમેહેર","મેહેર","સરોશ","રશને","ફરવદીન","બેહેરાંમ","રાંમ","ગોવાદ","દએપદીન","દીન","અશીશવંઘ","આશતાદ","આસમાન","જમીઆદ","મારેસ્પંદ","અનેરાંન","અહુનવદ","ઉસ્તવદ","સ્પેનતોમદ","વોહુક્ષથ્ર","વહીશ્તોઇસ્ત"]
    
    static func name(index:Int) -> String {
        if NSUserDefaults(suiteName: "group.com.borisinc.ParsiCalendar")?.stringForKey("language") == "gu" {
            return "રોજ: " + WkDayNames.gu[index]
        }
        return "Roj: " + WkDayNames.en[index]
    }
}

enum WkDates {
    static let pYear:CInt = 1383
    static let gregDate = NSDate.fromComponents(18, month:8, year:2013)
    
    static let impDays = [0,2,8,16,18,19]
}

enum WkColors {
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

class WkCalendar: NSObject {
    
    class func getParsiYear(date:NSDate) -> CInt {
        var dtc = date.components()
        var dt = NSDate.fromComponents(dtc.day, month: dtc.month, year: dtc.year)
        
        var days = dt.daysSince(WkDates.gregDate)
        var day = NSNumber(integer: days).floatValue / 365.0
        return WkDates.pYear + NSNumber(float: floor(day)).integerValue
    }
    
    class func yearLabel(year:CInt) -> String {
        /*if NSUserDefaults(suiteName: "com.borisinc.ParsiCalendar").stringForKey("language") == "gu" {
        let y = Int(year)
        let numbers = ["૦","૧","૨","૩","૪","૫","૬","૭","૮","૯"]
        var yr:String = ""
        yr += numbers[y % 10]
        yr += numbers[y % 100 / 10]
        yr += numbers[y % 1000 / 100]
        yr += numbers[y % 10000 / 1000]
        return "\(yr) YZ";
        }*/
        return "\(year) YZ"
    }
    
    class func getParsiMonth(date:NSDate)  -> Int {
        var dtc = date.components()
        var dt = NSDate.fromComponents(dtc.day, month: dtc.month, year: dtc.year)
        
        var days = dt.daysSince(WkDates.gregDate)
        var day = days % 365
        if(day < 0) { day = 365+day }
        var diff = day / 30
        
        if abs(day) >= 360 {
            return 11
        }
        
        return abs(diff)
    }
    
    
    class func getParsiDay(date:NSDate)  -> Int {
        var dtc = date.components()
        var dt = NSDate.fromComponents(dtc.day, month: dtc.month, year: dtc.year)
        
        var days = dt.daysSince(WkDates.gregDate)
        var day = days % 365
        if(day < 0) { day = 365+day }
        var diff = day % 30
        
        if(day >= 360) { diff+=30 }
        
        return abs(diff)
    }
}
