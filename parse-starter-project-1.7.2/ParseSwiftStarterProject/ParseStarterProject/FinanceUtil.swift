//
//  FinanceUtil.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/24/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation

class FinanceUtil {
    
    class func isMonthInMidYearPeriod(month: Int) -> Bool {
        return month > 2 && month < 9
    }
    
    class func isMonthInToNextYearPeriod(month: Int) -> Bool {
        return month < 3 || month > 8
    }
    
    class func isMonthAtFirstHalfOfYear(month: Int) -> Bool {
        return month >= 1 && month <= 6
    }
    
    class func getCurrentComponents() -> NSDateComponents {
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let currentDate = NSDate()
        let timeZone = NSTimeZone(name: EST_ZONE)
        return NSCalendar.currentCalendar().componentsInTimeZone(timeZone!, fromDate: currentDate)
    }
    
    class func getCurrentFinancialPeriodDate(currentComps: NSDateComponents) -> NSDate {
        let components = NSDateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        if FinanceUtil.isMonthInMidYearPeriod(currentComps.month) {
            components.year = currentComps.year
            components.month = 8
            components.day = 31
        } else {
            if isMonthAtFirstHalfOfYear(currentComps.month) {
                components.year = currentComps.year
            } else {
                components.year = currentComps.year + 1
            }
            components.month = 2
            components.day = 28
        }
        
        components.timeZone = NSTimeZone(name: EST_ZONE)
        let gregorian = NSCalendar(identifier: NSGregorianCalendar)
        let date = gregorian!.dateFromComponents(components)
        return date!
    }
    
    class func getNextFinancialPeriodDate(currentComps: NSDateComponents) -> NSDate {
        let components = NSDateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        if FinanceUtil.isMonthInMidYearPeriod(currentComps.month) {
            components.year = currentComps.year + 1
            components.month = 2
            components.day = 28
        } else {
            if isMonthAtFirstHalfOfYear(currentComps.month) {
                components.year = currentComps.year
            } else {
                components.year = currentComps.year + 1
            }
            components.month = 8
            components.day = 31
        }
        
        components.timeZone = NSTimeZone(name: EST_ZONE)
        let gregorian = NSCalendar(identifier: NSGregorianCalendar)
        let date = gregorian!.dateFromComponents(components)
        return date!
    }
    
    //the next after next
    class func getFurtherFinancialPeriodDate(currentComps: NSDateComponents) -> NSDate {
        let components = NSDateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        if FinanceUtil.isMonthInMidYearPeriod(currentComps.month) {
            components.year = currentComps.year + 1
            components.month = 8
            components.day = 31
        } else {
            if isMonthAtFirstHalfOfYear(currentComps.month) {
                components.year = currentComps.year + 1
            } else {
                components.year = currentComps.year + 2
            }
            components.month = 2
            components.day = 28
        }
        
        components.timeZone = NSTimeZone(name: EST_ZONE)
        let gregorian = NSCalendar(identifier: NSGregorianCalendar)
        let date = gregorian!.dateFromComponents(components)
        return date!
    }
    
    class func getCurrentFinancialPeriodStartDate(currentComps: NSDateComponents) -> NSDate {
        let components = NSDateComponents()
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        if FinanceUtil.isMonthInMidYearPeriod(currentComps.month) {
            components.year = currentComps.year
            components.month = 3
            components.day = 1
        } else {
            if isMonthAtFirstHalfOfYear(currentComps.month) {
                components.year = currentComps.year - 1
            } else {
                components.year = currentComps.year
            }
            components.month = 9
            components.day = 1
        }
        
        components.timeZone = NSTimeZone(name: EST_ZONE)
        let gregorian = NSCalendar(identifier: NSGregorianCalendar)
        let date = gregorian!.dateFromComponents(components)
        return date!
    }
}