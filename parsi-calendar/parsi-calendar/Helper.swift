//
//  Helper.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/12/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

enum Colors {
    static var weekendColor:UIColor {
    return UIColor(hue:150.0/360.0, saturation:0.7, brightness:0.4, alpha:1.0)
        //return UIColor(hue:210.0/360.0, saturation:1.0, brightness:0.5, alpha:1.0)
    }
    
    static var importantDay:UIColor {
    return UIColor(hue:1.0, saturation:1.0, brightness:0.9, alpha:1.0)
    }
    
    static var gathaDay:UIColor {
    return UIColor(hue:150.0/360.0, saturation:1.0, brightness:0.5, alpha:1.0)
    }
    
    static var today:UIColor {
    return UIColor(hue:90.0/360.0, saturation:0.9, brightness:0.6, alpha:0.1)
    }
    
    static var todayBorder:UIColor {
    return UIColor(hue:90.0/360.0, saturation:0.9, brightness:0.6, alpha:0.5)
    }
    
}

// static variables
enum Statics {
    static let infoDictionary = NSBundle.mainBundle().infoDictionary
    static let userDefaults = NSUserDefaults(suiteName: "com.borisinc.ParsiCalendar")
    
    static let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    static var window:UIWindow? {
    return Statics.appDelegate.window!
    }
    
    static var windowImage:UIImage?
    
    static var indicatorView:UIView?
    
    static var rootView:UINavigationController? {
    return Statics.window!.rootViewController as? UINavigationController
    }
}

enum BundleFields {
    static var appTitle:AnyObject {
    return Statics.infoDictionary["CFBundleDisplayName"]!
    }
    static var version:AnyObject {
    return Statics.infoDictionary["CFBundleShortVersionString"]!
    }
    static var build:AnyObject {
    return Statics.infoDictionary["CFBundleVersion"]!
    }
    
    static var versionString:String {
    return "Version: \(BundleFields.version) (Build:\(BundleFields.build))"
    }
}

class Helper: NSObject {
    
    class func showAlert(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        Statics.rootView!.presentViewController(alert, animated: true, completion: nil)
    }
}
