//
//  EditTextViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/16/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditTextViewController: UIViewController {
    var editObject: PFObject!
    var objectClass: String!
    var editAttribute: String!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = editObject[editAttribute] as? String
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        var attribute = textField.text
        if count(attribute) > 0 {
            editObject[editAttribute] = attribute as String
            editObject.saveEventually()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
