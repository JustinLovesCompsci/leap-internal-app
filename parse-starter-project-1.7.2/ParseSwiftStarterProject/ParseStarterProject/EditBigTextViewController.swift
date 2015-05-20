//
//  EditBigTextViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/19/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditBigTextViewController: UIViewController {
    var editObject: PFObject!
    var objectClass: String!
    var editAttribute: String!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func donePressed(sender: AnyObject) {
        var attribute = textView.text
        
        if count(attribute) > 0 {
            editObject[editAttribute] = attribute as String
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            popEmptyAttributeAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = editObject[editAttribute] as? String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    func popEmptyAttributeAlert() {
        var alert = UIAlertController(title: "Oops...", message: "Field cannot be empty", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction!) in
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
