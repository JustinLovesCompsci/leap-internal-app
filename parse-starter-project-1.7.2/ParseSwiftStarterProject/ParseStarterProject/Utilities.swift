//
//  Utilities.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/10/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Utilities {
    
    class func loginUser(target: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewControllerWithIdentifier("navigationVC") as! UINavigationController
        target.presentViewController(welcomeVC, animated: true, completion: nil)
    }
    
    class func postNotification(notification: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
    }
    
    class func isIdenticalPFObject(obj1:PFObject, obj2:PFObject) -> Bool {
        if  obj1.parseClassName == obj2.parseClassName && obj1.objectId == obj2.objectId {
            return true
        }
        return false
    }
    
    class func getFormattedTextFromDate(date:NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr.substringToIndex(dateStr.rangeOfString(",")!.startIndex)
    }
    
    // no time
    class func getLongTextFromDate(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    class func isExecUser() -> Bool {
        if let user:PFObject = PFUser.currentUser() {
            if let types = user[PF_USER_TYPES] as? [String] {
                return contains(types, PF_TYPE_EXEC)
            }
        }
        return false
    }
    
    class func isMentorUser() -> Bool {
        if let user:PFObject = PFUser.currentUser() {
            if let types = user[PF_USER_TYPES] as? [String] {
                return contains(types, PF_TYPE_MENTOR)
            }
        }
        return false
    }
    
    class func isStudentRepUser() -> Bool {
        if let user:PFObject = PFUser.currentUser() {
            if let types = user[PF_USER_TYPES] as? [String] {
                return contains(types, PF_TYPE_STUDENT_REP)
            }
        }
        return false
    }
    
    class func getEmailItems() -> [String] {
        var total_items = [String]()
        let emailItems = [ADMIN_EMAIL, MANAGE_EMAIL, SALES_EMAIL, SERVICE_EMAIL, MARKETING_EMAIL]
        total_items += emailItems
        if let user: PFObject = PFUser.currentUser() {
            total_items.append(user[PF_USER_EMAIL] as! String)
        }
        return total_items
    }
    
    class func getDueDateLimit() -> NSDate {
        var components = NSDateComponents()
        components.setValue(2, forComponent: NSCalendarUnit.CalendarUnitMonth);
        let date: NSDate = NSDate()
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))!
    }
    
    class func isGreaterThanDate(dateFrom: NSDate, dateTo: NSDate) -> Bool {
        return dateFrom.compare(dateTo) == NSComparisonResult.OrderedDescending
    }
    
    class func isSmallerThanDate(dateFrom: NSDate, dateTo: NSDate) -> Bool {
        return dateFrom.compare(dateTo) == NSComparisonResult.OrderedAscending
    }
    
    class func isSameAsDate(dateFrom: NSDate, dateTo: NSDate) -> Bool {
        return dateFrom.compare(dateTo) == NSComparisonResult.OrderedSame
    }
    
    class func getAllPublicACL() -> PFACL {
        let acl = PFACL()
        acl.setPublicReadAccess(true)
        acl.setPublicWriteAccess(true)
        return acl
    }
    
}
