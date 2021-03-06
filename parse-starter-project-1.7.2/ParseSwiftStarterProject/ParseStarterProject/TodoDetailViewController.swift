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
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBAction func changePressed(sender: AnyObject) {
        if InternetUtil.isConnectedToNetwork() {
            showChangeActionSheet()
        } else {
            InternetUtil.showNoInternetDialog(self)
        }
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
            navBar.rightBarButtonItem?.enabled = true
            navBar.rightBarButtonItem?.title = "Edit"
        } else {
            navBar.rightBarButtonItem?.enabled = false
            navBar.rightBarButtonItem?.title = ""
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        descriptionText.editable = false
        if let descrip = todo[PF_TODOS_DESCRIPTION] as? String {
            descriptionText.text = descrip
        } else {
            descriptionText.text = "None"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editTodoSegue" {
            let createVC = segue.destinationViewController as! EditTodoViewController
            createVC.editObject = todo
        } else if segue.identifier == "embedShowTodoSegue" {
            let createVC = segue.destinationViewController as! TodoShowTableViewController
            createVC.todo = todo
        }
    }
    
    func popDeleteAlert() {
        var deleteAlert = UIAlertController(title: "Are you sure?", message: "Delete this ToDo from all assignees", preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action:UIAlertAction!) in
            NSLog("Cancelled log out")
        }))
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action:UIAlertAction!) in
            HudUtil.showProgressHUD()
            self.todo.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                HudUtil.hidHUD()
                if success {
                    self.todo.unpinInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if success {
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            if let error = error {
                                NSLog("%@", error)
                            }
                            HudUtil.showErrorHUD("Cannot delete from local datastore")
                        }
                    }
                } else {
                    if let error = error {
                        NSLog("%@", error)
                    }
                    HudUtil.showErrorHUD("Check your network settings")
                }
            }
        }))
        
        presentViewController(deleteAlert, animated: true, completion: nil)
    }
}