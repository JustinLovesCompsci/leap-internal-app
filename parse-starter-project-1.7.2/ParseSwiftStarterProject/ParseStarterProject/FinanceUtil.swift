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
        return NSCalendar.currentCalendar().components(flags, fromDate: currentDate)
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
        
        let gregorian = NSCalendar(identifier: NSGregorianCalendar)
        let date = gregorian!.dateFromComponents(components)
        println("Current Finance Period ends on \(Utilities.getLongTextFromDate(date!))")
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
        
        let gregorian = NSCalendar(identifier: NSGregorianCalendar)
        let date = gregorian!.dateFromComponents(components)
        println("Next Finance Period ends on \(Utilities.getLongTextFromDate(date!))")
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
        
        let gregorian = NSCalendar(identifier: NSGregorianCalendar)
        let date = gregorian!.dateFromComponents(components)
        println("Next next Finance Period ends on \(Utilities.getLongTextFromDate(date!))")
        return date!
    }
    
}