//
//  EditDateViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/16/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditDateViewController: UIViewController {
    var editObject: PFObject!
    var objectClass: String!
    var editAttribute: String!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func savePressed(sender: AnyObject) {
        editObject[editAttribute] = datePicker.date
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}