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
        
        if editAttribute == PF_TODOS_SUMMARY && attribute == NEW_TODO_SUMMARY {
            var alert = UIAlertController(title: "Oops...", message: "Summary cannot be 'New ToDo'", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction!) in
            }))
            
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if count(attribute) > 0 {
            editObject[editAttribute] = attribute as String
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            popEmptyAttributeAlert()
        }
    }
    
    func popEmptyAttributeAlert() {
        var alert = UIAlertController(title: "Oops...", message: "Field cannot be empty", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction!) in
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
