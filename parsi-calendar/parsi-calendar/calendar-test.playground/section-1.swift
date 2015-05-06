// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var start = NSDate(timeIntervalSinceNow: -327*24*60*60)
var current = NSDate(timeIntervalSinceNow: 3*24*60*60)

var ti = current.timeIntervalSinceDate(start)

((floor((ti / (24*60*60))) % 365) % 30)

func getComponents(date:NSDate) -> NSDateComponents! {
    let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
    return cal?.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: date);
}


func fromComponents(day:Int, month:Int, year:Int) -> NSDate! {
    let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
    var components = getComponents(NSDate())
    
    components.day = day
    components.month = month
    components.year = year
    components.hour = 0
    components.minute = 0
    components.second = 0
    
    return cal?.dateFromComponents(components)
    
}
var names = ["Hormazd","Bahman","Ardibehesht","Shehrevar","Aspandard","Khordad","Amardad","Dae-pa-Adar","Adar","Avan","Khorshed","Meher","Tir","Gosh","Dae-pa-Meher","Meher","Srosh","Rashne","Fravardin","Behram","Ram","Govad","Dae-pa-Din","Din","Ashishvangh","Ashtad","Asman","Zamyad","Mareshpand","Aneran","Ahunavaiti","Ushtavaiti","Spentamainyu","Vohuxshathra","Vahishtoishti"]


364 % 30

1234 % 10
1234 % 100 / 10
1234 % 1000 / 100
1234 % 10000 / 1000


453%365

let st = fromComponents(18, 8, 2013)
let en = fromComponents(13, 8, 2013)

var st1:NSDate?, en1:NSDate?
let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
cal?.timeZone = NSTimeZone(abbreviation: "CDT")!
cal?.rangeOfUnit(.CalendarUnitDay, startDate: &st1, interval: nil, forDate: st)
cal?.rangeOfUnit(.CalendarUnitDay, startDate: &en1, interval: nil, forDate: en)
let startDay=cal?.ordinalityOfUnit(.CalendarUnitDay, inUnit: .EraCalendarUnit, forDate: st1!)
let endDay=cal?.ordinalityOfUnit(.CalendarUnitDay, inUnit: .EraCalendarUnit, forDate: en1!)

st1
en1

NSCalendarOptions.WrapComponents

let ddd = cal?.components(.CalendarUnitDay, fromDate: st1!, toDate: en1!, options: .WrapComponents)
(abs(ddd!.day))%365

var days = endDay!-startDay!
var day = days % 365
if(day < 0) { day = 365+day }
var diff = day % 30
if(day >= 360) { diff+=30 }

names[diff]
 