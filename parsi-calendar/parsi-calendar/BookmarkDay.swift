//
//  BookmarkDay.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/13/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import CoreData
import CloudKit
import UIKit

class BookmarkDay: NSManagedObject {
    
    @NSManaged var day: NSNumber
    @NSManaged var month: NSNumber
    @NSManaged var bookmarkTitle: NSString
    @NSManaged var identifier: NSString
    @NSManaged var isDefault: NSNumber
    @NSManaged var isSynced: NSNumber
    
    
    func remove() {
        let context = Statics.appDelegate.managedObjectContext
        context!.deleteObject(self)
        
        var id = self.identifier
        var error: NSError? = nil
        if !((context?.save(&error)) != nil) {
            println("Unresolved error \(error), \(error!.userInfo)")
        }
        else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if let _id = CKRecordID(recordName: id) {
                Statics.cloudDatabase.deleteRecordWithID(_id, completionHandler: { (_rec, err) -> Void in
                    if err != nil {
                        println("Unresolved error \(err), \(err!.userInfo)")
                    }
                })
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    class func insert(day:Int, month:Int, title:String, isDefault:Bool) {
        let context = Statics.appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Bookmarks", inManagedObjectContext: context!)
        
        let newEntry = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context!) as BookmarkDay
        newEntry.day = NSNumber(integer: day)
        newEntry.month = NSNumber(integer: month)
        newEntry.bookmarkTitle = title
        newEntry.isDefault = NSNumber(bool: isDefault)
        newEntry.identifier = NSUUID().UUIDString
        newEntry.isSynced = NSNumber(bool: false)
        
        var error: NSError? = nil
        if (!isDefault) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if let _id = CKRecordID(recordName: newEntry.identifier) {
                if let _rec = CKRecord(recordType: "BookmarkDay", recordID: _id) {
                    _rec.setObject(newEntry.day, forKey: "day")
                    _rec.setObject(newEntry.month, forKey: "month")
                    _rec.setObject(newEntry.bookmarkTitle, forKey: "bookmarkTitle")
                    _rec.setObject(newEntry.isDefault, forKey: "isDefault")
                    _rec.setObject(newEntry.identifier, forKey: "identifier")
                    
                    Statics.cloudDatabase.saveRecord(_rec, completionHandler: { (newRecord, err) -> Void in
                        if err != nil {
                            println("Unresolved error \(err), \(err!.userInfo)")
                        }
                        else {
                            newEntry.isSynced = NSNumber(bool: true)
                        }
                    });
                }
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        
        if !((context?.save(&error)) != nil) {
            println("Unresolved error \(error), \(error!.userInfo)")
        }
        else {
            if Statics.userDefaults!.boolForKey("add2calendar") {
                Statics.eventManager.addEvent(title, date: Calendar.getGregorianDate(day, month: month))
            }
        }
    }
    
    class func insertFromCloud(identifier:String, day:Int, month:Int, title:String, isDefault:Bool) {
        let context = Statics.appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Bookmarks", inManagedObjectContext: context!)
        
        let newEntry = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context!) as BookmarkDay
        newEntry.day = NSNumber(integer: day)
        newEntry.month = NSNumber(integer: month)
        newEntry.bookmarkTitle = title
        newEntry.isDefault = NSNumber(bool: isDefault)
        newEntry.identifier = identifier
        newEntry.isSynced = NSNumber(bool: true)
        
        var error: NSError? = nil
        if !((context?.save(&error)) != nil) {
            println("Unresolved error \(error), \(error!.userInfo)")
        }
    }
    
    class func removeAll() {
        let context = Statics.appDelegate.managedObjectContext
        let fetch = NSFetchRequest(entityName: "Bookmarks")
        
        var error: NSError? = nil
        
        var result:NSArray = context?.executeFetchRequest(fetch, error: &error) as NSArray!
        for item in result
        {
            if item.isDefault == 1 {
                context?.deleteObject(item as NSManagedObject)
            }
        }
        
        if !((context?.save(&error)) != nil) {
            println("Unresolved error \(error), \(error!.userInfo)")
        }
        else {
            
        }
    }
    
    class func setIdentifiers() {
        let context = Statics.appDelegate.managedObjectContext
        let fetch = NSFetchRequest(entityName: "Bookmarks")
        
        var error: NSError? = nil
        
        var result:NSArray = context?.executeFetchRequest(fetch, error: &error) as NSArray!
        for item in result
        {
            var rec = (item as BookmarkDay)
            rec.isSynced = NSNumber(bool: false)
            rec.identifier = rec.isDefault == 1 ? "0" : NSUUID().UUIDString
            if rec.isDefault == 0 {
                if let _id = CKRecordID(recordName: rec.identifier) {
                    if let _rec = CKRecord(recordType: "BookmarkDay", recordID: _id) {
                        _rec.setObject(rec.day, forKey: "day")
                        _rec.setObject(rec.month, forKey: "month")
                        _rec.setObject(rec.bookmarkTitle, forKey: "bookmarkTitle")
                        _rec.setObject(rec.isDefault, forKey: "isDefault")
                        _rec.setObject(rec.identifier, forKey: "identifier")
                        
                        Statics.cloudDatabase.saveRecord(_rec, completionHandler: { (newRecord, err) -> Void in
                            if err != nil {
                                println("Unresolved error \(err), \(err!.userInfo)")
                            }
                            else {
                                rec.isSynced = NSNumber(bool: true)
                            }
                        });
                    }
                }
            }
            
            if !((context?.save(&error)) != nil) {
                println("Unresolved error \(error), \(error!.userInfo)")
            }
        }
        
        if !((context?.save(&error)) != nil) {
            println("Unresolved error \(error), \(error!.userInfo)")
        }
    }
    
    class func icloudSync() {
        let context = Statics.appDelegate.managedObjectContext
        let fetch = NSFetchRequest(entityName: "Bookmarks")
        
        var error: NSError? = nil
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if let query = CKQuery(recordType: "BookmarkDay", predicate: NSPredicate(value: true)) {
            Statics.cloudDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (records, err) -> Void in
                if(err != nil) {
                    println("Unresolved error \(err), \(err!.userInfo)")
                }
                else {
                    for rec in records {
                        fetch.predicate = NSPredicate(format: "identifier == %@", rec["identifier"] as String)
                        if (context?.executeFetchRequest(fetch, error: &error) as NSArray!).count == 0 {
                            BookmarkDay.insertFromCloud(rec["identifier"] as String, day: rec["day"] as Int, month: rec["month"] as Int, title: rec["bookmarkTitle"] as String, isDefault: false)
                        }
                    }
                }
            })
        }
        fetch.predicate = NSPredicate(format: "isSynced == 0 && isDefault == 0")
        for rec in (context?.executeFetchRequest(fetch, error: &error) as NSArray!) {
            if let _id = CKRecordID(recordName: rec.identifier) {
                if let _rec = CKRecord(recordType: "BookmarkDay", recordID: _id) {
                    _rec.setObject(rec.day, forKey: "day")
                    _rec.setObject(rec.month, forKey: "month")
                    _rec.setObject(rec.bookmarkTitle, forKey: "bookmarkTitle")
                    _rec.setObject(rec.isDefault, forKey: "isDefault")
                    _rec.setObject(rec.identifier, forKey: "identifier")
                    
                    Statics.cloudDatabase.saveRecord(_rec, completionHandler: { (newRecord, err) -> Void in
                        if err != nil {
                            println("Unresolved error \(err), \(err!.userInfo)")
                        }
                        else {
                            //rec.isSynced = NSNumber(bool: true)
                        }
                    });
                }
            }
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}
