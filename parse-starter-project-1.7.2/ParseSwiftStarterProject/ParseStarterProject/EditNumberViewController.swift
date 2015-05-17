//
//  EditNumberViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/16/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditNumberViewController: UIViewController {
    var editObject: PFObject!
    var objectClass: String!
    var editAttribute: String!
    @IBOutlet weak var numberField: UITextField!
    
    @IBAction func donePressed(sender: AnyObject) {
        
        if let attribute = numberField.text.toInt() {
            if attribute > 0 {
                editObject[editAttribute] = attribute
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                popInvalidNumAlert()
            }
        } else {
            popInvalidNumAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let num = editObject[editAttribute] as? Int {
            numberField.text = String(num)
        }
    }
    
    func popInvalidNumAlert() {
        var alert = UIAlertController(title: "Oops...", message: "Please enter a valid number", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction!) in
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}