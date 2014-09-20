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
