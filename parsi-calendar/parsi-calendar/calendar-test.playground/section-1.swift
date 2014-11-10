// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var start = NSDate(timeIntervalSinceNow: -327*24*60*60)
var current = NSDate(timeIntervalSinceNow: 3*24*60*60)

var ti = current.timeIntervalSinceDate(start)

((floor((ti / (24*60*60))) % 365) % 30)



364 % 30

1234 % 10
1234 % 100 / 10
1234 % 1000 / 100
1234 % 10000 / 1000


453%365

let st = NSDate(timeIntervalSinceNow: -449*60*60*24)
let en = NSDate()

let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
let startDay=cal?.ordinalityOfUnit(.CalendarUnitDay, inUnit: .EraCalendarUnit, forDate: st)
let endDay=cal?.ordinalityOfUnit(.CalendarUnitDay, inUnit: .EraCalendarUnit, forDate: en)
endDay!-startDay!

449 % 365