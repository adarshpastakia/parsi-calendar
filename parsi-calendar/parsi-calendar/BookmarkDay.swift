//
//  BookmarkDay.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/13/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import CoreData

class BookmarkDay: NSManagedObject {
	
	@NSManaged var day: NSNumber
	@NSManaged var month: NSNumber
	@NSManaged var bookmarkTitle: NSString
	@NSManaged var isDefault: NSNumber
	
	
	class func insert(day:Int, month:Int, title:String, isDefault:Bool) {
		let context = Statics.appDelegate.managedObjectContext
		let entity = NSEntityDescription.entityForName("Bookmarks", inManagedObjectContext: context!)
		
		let newEntry = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context!) as BookmarkDay
		newEntry.day = NSNumber(integer: day)
		newEntry.month = NSNumber(integer: month)
		newEntry.bookmarkTitle = title
		newEntry.isDefault = NSNumber(bool: isDefault)
		
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
            context?.deleteObject(item as NSManagedObject)
        }
        
        if !((context?.save(&error)) != nil) {
            println("Unresolved error \(error), \(error!.userInfo)")
        }
    }
}
