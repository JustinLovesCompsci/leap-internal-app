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
        installation.removeObjectForKey(PF_CHANNEL)
        if Utilities.isExecUser() {
            installation.addUniqueObject(EXEC_CHANNEL, forKey: PF_CHANNEL)
        }
        if Utilities.isStudentRepUser() {
            installation.addUniqueObject(STUDENT_REP_CHANNEL, forKey: PF_CHANNEL)
        }
        if Utilities.isMentorUser() {
            installation.addUniqueObject(MENTORS_CHANNEL, forKey: PF_CHANNEL)
        }
        installation.addUniqueObject(BROADCAST_CHANNEL, forKey: PF_CHANNEL)
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
        if Utilities.isExecUser() {
            installation.removeObject(EXEC_CHANNEL, forKey: PF_CHANNEL)
        }
        if Utilities.isStudentRepUser() {
            installation.removeObject(STUDENT_REP_CHANNEL, forKey: PF_CHANNEL)
        }
        if Utilities.isMentorUser() {
            installation.removeObject(MENTORS_CHANNEL, forKey: PF_CHANNEL)
        }
        installation.removeObject(BROADCAST_CHANNEL, forKey: PF_CHANNEL)
        installation.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                println("parsePushUserResign save error")
            }
        }
    }
}