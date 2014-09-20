//
//  Calendar.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/11/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit
import CoreData

enum MonthNames {
    static var en = ["FRAVARDIN","ARDIBEHESHT","KHORDAD","TIR","AMARDAD","SHEHREVAR","MEHER","AVAN","ADAR","DAE","BAHMAN","ASPANDARD"]
    static var gj = ["ષરાવારદિન","આરદિભેસથ","કહોરદાદ","તીર","અમરદાદ","સહેહરેવાર","મેહેર","આવન","આદર","દે","બાહમાન","અસપાનદારદ"]
    
    static func name(index:Int) -> String {
        if Statics.userDefaults.stringForKey("language") == "gj" {
            return MonthNames.gj[index]
        }
        return MonthNames.en[index];
    }
}

enum DayNames {
    static var en = ["Hormazd","Bahman","Ardibehesht","Shehrevar","Aspandard","Khordad","Amardad","Dae-pa-Adar","Adar","Avan","Khorshed","Meher","Tir","Gosh","Dae-pa-Meher","Meher","Srosh","Rashne","Fravardin","Behram","Ram","Govad","Dae-pa-Din","Din","Ashishvangh","Ashtad","Asman","Zamyad","Mareshpand","Aneran","Ahunavaiti","Ushtavaiti","Spentamainyu","Vohuxshathra","Vahishtoishti"]
    static var gj = ["હોરમઙદ","બહમન","આરદિભેસથ","સહેહરેવાર","આઅસપાનદારદ","કહોરદાદ","અમરદાદ","દે-પા-દાર","આદર","આવન","ખોરશેદ","મેહેર","તીર","ગોશ","દે-પા-દાર","મેહેર","સરોશ","રાશને","ષરાવારદિન","બેહરામ","રામ","ગોવાદ","દે-પા-દીન","દીન","આશિશવાનઘ","આશતાદ","આસમાન","ઙમયાદ","મારેસપાનદ","અનેરાન","અહુનાવઉતિ","ઇશતાવઉતિ","સપેનતામઉનયુ","વોહુષસહાતરા","વાહિસહતોિસહતિ"]
    
    static func name(index:Int) -> String {
        if Statics.userDefaults.stringForKey("language") == "gj" {
            return DayNames.gj[index]
        }
        return DayNames.en[index]
    }
}

enum Dates {
    static let pYear:CInt = 1383
    static let gregDate = NSDate.fromComponents(18, month:8, year:2013)
    
    static let impDays = [0,2,8,16,18,19]
}

class Calendar: NSObject {
    
    class func getParsiYear(date:NSDate) -> CInt {
        let ti = date.timeIntervalSinceDate(Dates.gregDate)
        var diff:NSNumber = 0
        
        if ti > 0 {
            diff = floor((ti / (24*60*60))/365)
        }
        else {
            diff = ceil((ti / (24*60*60))/365)
        }
        return Dates.pYear + diff.intValue
    }
    
    class func yearLabel(year:CInt) -> String {
        if Statics.userDefaults.stringForKey("language") == "gj" {
            let y = Int(year)
            let numbers = ["૦","૧","૨","૩","૪","૫","૬","૭","૮","૯"]
            var yr:String = ""
            yr += numbers[y % 10]
            yr += numbers[y % 100 / 10]
            yr += numbers[y % 1000 / 100]
            yr += numbers[y % 10000 / 1000]
            return yr;
        }
        return "\(year)"
    }
    
    class func getParsiMonth(date:NSDate)  -> Int {
        let ti = date.timeIntervalSinceDate(Dates.gregDate)
        
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
        let ti = date.timeIntervalSinceDate(Dates.gregDate)
        
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
    
    class func isSpecialDay(dt:NSDate) -> Bool {
        let day = Calendar.getParsiDay(dt)
        let month = Calendar.getParsiMonth(dt)
        
        if contains(Dates.impDays, day) {
            return true
        }
        if day == 9 && month == 7 {
            return true
        }
        
        return false
    }
    
    class func bookmarkLabel(lbl:String) -> String {
        let labels = [
            "Jamshedji Navroz"      : "જમસહેદજિ નાવરોઙ",
            "Navroz"                : "નાવરોઙ",
            "Khordad Saal"          : "કહોરદાદ સાલ",
            "Ava Ardvisur"          : "આવા ારદવિસુર",
            "Adar Yazad Jashan"     : "આદાર યાઙાદ જસહન",
            "Zarthost no Diso"      : "ઙારતહોસહત નો દિસો",
            "Homaji ni Baj"         : "હોમાજી નિ બાજ",
            "First Gatha"           : "પેહલો ગહાતો",
            "Second Gatha"          : "બિજો ગહાતો",
            "Third Gatha"           : "તિજો ગહાતો",
            "Fourth Gatha"          : "ચહોતો ગહાતો",
            "Fifth Gatha (Papeti)"  : "પાનચહવો ગહાતો (પપેતિ)"
        ]
        if Statics.userDefaults.stringForKey("language") == "gj" {
            return labels[lbl]!
        }
        return lbl
    }
    
    class func getDayExtraForCell(dt:NSDate) -> [String]! {
        let day = Calendar.getParsiDay(dt)
        let month = Calendar.getParsiMonth(dt)
        
        var returnValue:[String] = []
        
        let context = Statics.appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Bookmarks", inManagedObjectContext: context!)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        fetchRequest.predicate = NSPredicate(format: "self.day == %@ && self.month == %@", NSNumber(integer: day), NSNumber(integer: month))
        
        var count = 3
        if dt.on(NSDate.fromComponents(21, month: 3, year: dt.components().year)) {
            returnValue.append(bookmarkLabel("Jamshedji Navroz"))
            count -= returnValue.count
        }
        
        var error: NSError? = nil
        if let results = context?.executeFetchRequest(fetchRequest, error: &error) {
            for o:AnyObject in results {
                returnValue.append(bookmarkLabel((o as BookmarkDay).bookmarkTitle))
                if returnValue.count == 2 && results.count > count {
                    returnValue.append("\(results.count - 2) more…")
                    return returnValue
                }
            }
        }
        
        
        return returnValue
    }
    
    class func getDayExtraForAlert(dt:NSDate) -> String! {
        let day = Calendar.getParsiDay(dt)
        let month = Calendar.getParsiMonth(dt)
        
        var returnValue:String = ""
        
        let context = Statics.appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Bookmarks", inManagedObjectContext: context!)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        fetchRequest.predicate = NSPredicate(format: "self.day == %@ && self.month == %@", NSNumber(integer: day), NSNumber(integer: month))
        
        var error: NSError? = nil, idx = 0
        
        if dt.on(NSDate.fromComponents(21, month: 3, year: dt.components().year)) {
            returnValue += bookmarkLabel("Jamshedji Navroz") + "\n"
        }
        
        if let results = context?.executeFetchRequest(fetchRequest, error: &error) {
            for o:AnyObject in results {
                returnValue += bookmarkLabel((o as BookmarkDay).bookmarkTitle) + "\n"
            }
        }
        
        
        return returnValue
    }
    
}
