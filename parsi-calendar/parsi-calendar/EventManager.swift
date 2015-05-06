//
//  EventManager.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 01/02/2015.
//  Copyright (c) 2015 Boris Inc. All rights reserved.
//

import UIKit
import EventKit

class EventManager: NSObject {
    
    var accessGranted = false
    var eventStore = EKEventStore()
    
    var myCalendar:EKCalendar?
    
    override init() {
        super.init()
        return;
            
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {(granted:Bool, error:NSError!) in
            self.accessGranted = granted
            if granted {
                self.myCalendar = self.eventStore.calendarWithIdentifier("CalendarIdentifier")
                if self.myCalendar == nil {
                    var error: NSError? = nil
                    self.myCalendar = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: self.eventStore)
                    self.myCalendar!.title = "Parsi Calendar"
                    self.myCalendar!.CGColor = UIColor(red:0.337255, green:0.592157, blue:0.125490, alpha:1.0).CGColor
                    self.myCalendar!.source = self.getSource()
                    self.eventStore.saveCalendar(self.myCalendar!, commit: true, error: &error)
                    if error != nil {
                        println("Unresolved error \(error), \(error!.userInfo)")
                    }
                    else {
                        Statics.userDefaults?.setObject(self.myCalendar!.calendarIdentifier, forKey: "CalendarIdentifier")
                    }
                }
            }
        });
    }
    
    func addEvent(title:String, date:NSDate) {
        if let evt = EKEvent(eventStore: eventStore) {
            evt.title = title
            evt.startDate = date
            evt.endDate = date
            evt.calendar = self.myCalendar
            
            var error: NSError? = nil
            self.eventStore.saveEvent(evt, span: EKSpanThisEvent, error: &error)
            if error != nil {
                println("Unresolved error \(error), \(error!.userInfo)")
            }
        }
    }
    
    func getSource() -> EKSource {
        var localSource:EKSource?
        var cloudSource:EKSource?
        for source in self.eventStore.sources() {
            if source.sourceType.value == EKSourceTypeCalDAV.value && source.title == "iCloud" {
                cloudSource = source as? EKSource;
            }
            if source.sourceType.value == EKSourceTypeLocal.value {
                localSource = source as? EKSource;
            }
        }
        
        return cloudSource != nil ? cloudSource! : localSource!
    }
}
