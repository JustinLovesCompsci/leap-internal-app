//
//  InternetUtil.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/23/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class InternetUtil {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    
    class func showNoInternetDialog(controller: UIViewController) {
        var alert = UIAlertController(title: "No Internet", message:"Please check network settings or enable VPN if you are in China. Note that displayed data may not be synced", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func showNoInternetHUD(controller: UIViewController) {
        HudUtil.showWarningHUD("No Internet", subtitle: "Connect to Internet or via VPN if in China")
    }

}