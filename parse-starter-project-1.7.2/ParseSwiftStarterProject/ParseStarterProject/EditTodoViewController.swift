//
//  EditTodoViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/16/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditTodoViewController: UITableViewController {
    var editObject: PFObject!
    var toEditAttribute: String!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!

    @IBAction func savePressed(sender: AnyObject) {
        if !allFieldsFilled() {
            popIncorrectFieldsAlert()
            return
        }
        
        if !InternetUtil.isConnectedToNetwork() {
            InternetUtil.showNoInternetDialog(self)
            return
        }
        
        HudUtil.showProgressHUD()
        let user = PFUser.currentUser()!
        editObject[PF_TODOS_CREATED_BY_PERSON] = user[PF_USER_NAME] as? String
        editObject.ACL = Utilities.getAllPublicACL()
        editObject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            HudUtil.hidHUD()
            if success {
                self.editObject.pinInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if success {
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        if let error = error {
                            NSLog("%@", error)
                        }
                        HudUtil.showErrorHUD("Cannot save to phone")
                    }
                }
            } else {
                if let error = error {
                    NSLog("%@", error)
                }
                HudUtil.showErrorHUD("Check your network settings")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func popIncorrectFieldsAlert() {
        var alert = UIAlertController(title: "Incorrect Fields", message:"Please fill in all fields correctly", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func allFieldsFilled() -> Bool {
        if let summary = editObject[PF_TODOS_SUMMARY] as? String, descrip = editObject[PF_TODOS_DESCRIPTION] as? String, dueDate = editObject[PF_TODOS_DUE_DATE] as? NSDate {
            
            if count(summary) == 0 || count(descrip) == 0 || Utilities.isSmallerThanDate(dueDate, dateTo: NSDate()) {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "editTodoCell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        switch (indexPath.row) {
        case 0:
            cell.textLabel?.text = "Summary"
            cell.detailTextLabel?.text = editObject[PF_TODOS_SUMMARY] as? String
        case 1:
            cell.textLabel?.text = "Description"
            cell.detailTextLabel?.text = editObject[PF_TODOS_DESCRIPTION] as? String
        case 2:
            cell.textLabel?.text = "Due Date"
            cell.detailTextLabel?.text = Utilities.getFormattedTextFromDate(editObject[PF_TODOS_DUE_DATE] as! NSDate)
        case 3:
            cell.textLabel?.text = "Contact Email"
            cell.detailTextLabel?.text = editObject[PF_TODOS_CREATED_BY_EMAIL] as? String
        default:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch (indexPath.row) {
        case 0:
            toEditAttribute = PF_TODOS_SUMMARY
            performSegueWithIdentifier("editTodoTextSegue", sender: self)
        case 1:
            toEditAttribute = PF_TODOS_DESCRIPTION
            performSegueWithIdentifier("editBigTextSegue", sender: self)
        case 2:
            toEditAttribute = PF_TODOS_DUE_DATE
            performSegueWithIdentifier("editTodoDateSegue", sender: self)
        case 3:
            toEditAttribute = PF_TODOS_CREATED_BY_EMAIL
            performSegueWithIdentifier("editChoiceSegue", sender: self)
        default:
            performSegueWithIdentifier("editTodoTextSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editTodoTextSegue" {
            let createVC = segue.destinationViewController as! EditTextViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_GEN_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
            
        } else if segue.identifier == "editTodoDateSegue" {
            let createVC = segue.destinationViewController as! EditDateViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_GEN_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
        } else if segue.identifier == "editBigTextSegue" {
            let createVC = segue.destinationViewController as! EditBigTextViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_GEN_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
        } else if segue.identifier == "editChoiceSegue" {
            let createVC = segue.destinationViewController as! EditChoiceViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_GEN_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
            createVC.items += Utilities.getEmailItems()
        }
    }
    
}
