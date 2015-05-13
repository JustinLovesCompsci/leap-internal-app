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
    
    class func isExecUser() -> Bool {
        if PFUser.currentUser() == nil {
            return false
        }
        let currentUser = PFUser.currentUser()
//        return currentUser[PF_USER_IS_EXEC] as! boolean_t
        return false
    }
    
    class func getDueDateLimit() -> NSDate {
        var components = NSDateComponents()
        components.setValue(1, forComponent: NSCalendarUnit.CalendarUnitMonth);
        let date: NSDate = NSDate()
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))!
    }
    
}
