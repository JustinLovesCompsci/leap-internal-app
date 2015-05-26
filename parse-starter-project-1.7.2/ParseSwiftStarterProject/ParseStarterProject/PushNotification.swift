//
//  PushNotification.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/11/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import Parse

class PushNotication {
    
    class func installUserForPush() {
        var installation = PFInstallation.currentInstallation()
        installation[PF_INSTALLATION_USER] = PFUser.currentUser()
        if Utilities.isExecUser() {
            installation.addUniqueObject(EXEC_CHANNEL, forKey: PF_CHANNEL)
        }
        installation.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                println("parsePushUserAssign save error.")
            }
        }
    }

    class func uninstallUserForPush() {
        var installation = PFInstallation.currentInstallation()
        installation.removeObjectForKey(PF_INSTALLATION_USER)
        installation.removeObject(EXEC_CHANNEL, forKey: PF_CHANNEL)
        installation.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                println("parsePushUserResign save error")
            }
        }
    }
    
    class func updateTodos() {
        PFObject.unpinAllObjectsInBackgroundWithName(TODO_DATA_TAG) {
            (success: Bool, error: NSError?) -> Void in
            
            var query = PFQuery(className: PF_GEN_TODOS_CLASS_NAME)
            query.orderByAscending(PF_GEN_TODOS_DUE_DATE)
            
            query.whereKey(PF_GEN_TODOS_DUE_DATE, greaterThanOrEqualTo: NSDate())
            query.whereKey(PF_GEN_TODOS_DUE_DATE, lessThanOrEqualTo: Utilities.getDueDateLimit())
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if objects != nil && objects?.count > 0 {
                        for object in objects as! [PFObject]! {
                            object.pinInBackgroundWithName(TODO_DATA_TAG)
                        }
                    }
                } else {
                    println(error)
                }
            }
        }
    }

//    class func sendPushNotification(groupId: String, text: String) {
//        var query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
//        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
//        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.currentUser())
//        query.includeKey(PF_MESSAGES_USER)
//        query.limit = 1000
//        
//        var installationQuery = PFInstallation.query()
//        installationQuery.whereKey(PF_INSTALLATION_USER, matchesKey: PF_MESSAGES_USER, inQuery: query)
//        
//        var push = PFPush()
//        push.setQuery(installationQuery)
//        push.setMessage(text)
//        push.sendPushInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
//            if error != nil {
//                println("sendPushNotification error")
//            }
//        }
//    }
    
}