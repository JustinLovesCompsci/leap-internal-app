//
//  TodoDetailViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/12/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import Parse

class TodoDetailViewController: UIViewController {
    
    var todo: PFObject!
    
    @IBOutlet weak var summaryField: UILabel!
    @IBOutlet weak var descriptionField: UILabel!
    @IBOutlet weak var DueDateField: UILabel!
    @IBOutlet weak var createByField: UILabel!
    
    @IBAction func saveCalendarPressed(sender: AnyObject) {
        
    }
    
    @IBAction func askPressed(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryField.text = "Summary: \(todo[PF_TODOS_SUMMARY] as! String)"
        if let descrip = todo[PF_TODOS_DESCRIPTION] as? String {
            descriptionField.text = descrip
        } else {
            descriptionField.text = "None"
        }
        DueDateField.text = "Due By \(Utilities.getFormattedTextFromDate(todo[PF_TODOS_DUE_DATE] as! NSDate))"
        createByField.text = "Created By \(todo[PF_TODOS_CREATED_BY_PERSON] as! String)"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* only support portrait */
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
}