//
//  MyPFLogInViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/15/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import ParseUI
import UIKit

class MyPFLogInViewController: PFLogInViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: customize background color
        let logoView = UIImageView(image: UIImage(named: "Logo"))
        logInView!.logo = logoView
    }
}
