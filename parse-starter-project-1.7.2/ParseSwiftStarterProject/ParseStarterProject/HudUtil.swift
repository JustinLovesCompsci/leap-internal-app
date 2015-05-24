//
//  HudUtil.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/22/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation

class HudUtil {
    
    class func showProgressHUD() {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
    }
    
    class func hidHUD() {
        PKHUD.sharedHUD.hide(animated: true)
    }
    
    class func showSuccessHUD(subtitle: String) {
        PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: subtitle, image: PKHUDAssets.checkmarkImage)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2.0)
    }
    
    class func showErrorHUD(subtitle: String) {
        PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: subtitle, image: PKHUDAssets.crossImage)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2.0)
    }
    
    class func showWarningHUD(title: String, subtitle: String) {
        PKHUD.sharedHUD.contentView = PKHUDStatusView(title: title, subtitle: subtitle, image: PKHUDAssets.bundledImage(named: "warning"))
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.5)
    }
}