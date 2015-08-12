//
//  DataUtil.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 6/6/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import Parse

class DataUtil {
    
    class func deleteRecord(record: PFObject!, controller: UIViewController) {
        HudUtil.showProgressHUD()
        record.deleteInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            HudUtil.hidHUD()
            if success {
                record.unpinInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if success {
                        controller.navigationController?.popViewControllerAnimated(true)
                    } else {
                        if let error = error {
                            NSLog("%@", error)
                        }
                        HudUtil.showErrorHUD("Cannot delete from local datastore")
                    }
                }
            } else {
                if let error = error {
                    NSLog("%@", error)
                }
                HudUtil.showErrorHUD("Check your network settings")
            }
        }
    }
}