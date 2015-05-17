//
//  TodoDetailViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/12/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import Parse

class TodoDetailViewController: UIViewController, UIActionSheetDelegate {
    
    var todo: PFObject!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var summaryField: UILabel!
    @IBOutlet weak var descriptionField: UILabel!
    @IBOutlet weak var DueDateField: UILabel!
    @IBOutlet weak var createByField: UILabel!
    
    @IBAction func saveCalendarPressed(sender: AnyObject) {
        
    }
    
    @IBAction func askPressed(sender: AnyObject) {
        
    }
    
    @IBAction func changePressed(sender: AnyObject) {
        showChangeActionSheet()
    }
    
    func showChangeActionSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Edit", "Delete")
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            switch buttonIndex {
            case 1:
                performSegueWithIdentifier("editTodoSegue", sender: self)
            case 2:
                popDeleteAlert()
            default:
                println("No record action selected")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Utilities.isExecUser() {
            self.navBar.rightBarButtonItem?.enabled = true
        } else {
            self.navBar.rightBarButtonItem?.enabled = false
        }
        
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editTodoSegue" {
            let createVC = segue.destinationViewController as! EditTodoViewController
            createVC.editObject = todo
        }
    }
    
    func popDeleteAlert() {
        var deleteAlert = UIAlertController(title: "Delete This ToDo", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action:UIAlertAction!) in
            NSLog("Cancelled log out")
        }))
        deleteAlert.addAction(UIAlertAction(title: "Remove", style: .Default, handler: { (action:UIAlertAction!) in
            self.todo.deleteEventually()
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        presentViewController(deleteAlert, animated: true, completion: nil)
    }
}