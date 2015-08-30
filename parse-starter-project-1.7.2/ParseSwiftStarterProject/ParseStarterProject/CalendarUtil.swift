//
//  CalendarUtil.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/21/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import EventKit
import Parse

class CalendarUtil {
    
    class func setTimeZone(date: NSDate) -> NSDate {
        var calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(name: EST_ZONE)!
        let components = calendar.components((.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute), fromDate: date)
        components.timeZone = NSTimeZone(name: EST_ZONE)
        return calendar.dateFromComponents(components)!
    }
}