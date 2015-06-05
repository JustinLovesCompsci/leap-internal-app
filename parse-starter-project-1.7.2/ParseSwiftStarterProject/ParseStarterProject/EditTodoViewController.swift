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

class EditTodoViewController: UITableViewController, UIActionSheetDelegate, SelectMultipleDelegate {
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
                self.navigationController?.popViewControllerAnimated(true)
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
    
    func getNumUsers() -> Int {
        if let users = editObject[PF_TODOS_USER_LIST] as? [PFUser] {
            return users.count
        }
        return 0
    }
    
    func hasSelectedAssignee() -> Bool {
        let numAssignee = getNumUsers()
        return numAssignee > 0 || editObject[PF_TODOS_TYPE] as? String != TO_SELECT_TYPE
    }
    
    func popIncorrectFieldsAlert() {
        var alert = UIAlertController(title: "Incorrect Fields", message:"Please fill in all fields correctly", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func allFieldsFilled() -> Bool {
        if let summary = editObject[PF_TODOS_SUMMARY] as? String, descrip = editObject[PF_TODOS_DESCRIPTION] as? String, dueDate = editObject[PF_TODOS_DUE_DATE] as? NSDate {
            
            if !hasSelectedAssignee() || count(summary) == 0 || count(descrip) == 0 || Utilities.isSmallerThanDate(dueDate, dateTo: NSDate()) {
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
        return 5
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
        case 4:
            cell.textLabel?.text = "Assignee"
            if let type = editObject[PF_TODOS_TYPE] as? String {
                if type == TO_SELECT_TYPE {
                    cell.detailTextLabel?.text = String(getNumUsers()) + " people"
                } else {
                    cell.detailTextLabel?.text = type
                }
            } else {
                cell.detailTextLabel?.text = "Not Defined"
            }
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
        case 4:
            toEditAttribute = PF_TODOS_USER_LIST
            showEditAssigneeSheet()
        default:
            performSegueWithIdentifier("editTodoTextSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editTodoTextSegue" {
            let createVC = segue.destinationViewController as! EditTextViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
            
        } else if segue.identifier == "editTodoDateSegue" {
            let createVC = segue.destinationViewController as! EditDateViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
        } else if segue.identifier == "editBigTextSegue" {
            let createVC = segue.destinationViewController as! EditBigTextViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
        } else if segue.identifier == "editChoiceSegue" {
            let createVC = segue.destinationViewController as! EditChoiceViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
            createVC.items += Utilities.getEmailItems()
        } else if segue.identifier == "editUserListSegue" {
            let createVC = segue.destinationViewController as! SelectMultipleViewController
            createVC.delegate = self
        }
    }
    
    func showEditAssigneeSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: TO_ALL_TYPE, TO_MENTORS_TYPE, TO_EXEC_TYPE, TO_STUDENT_REPS_TYPE, TO_SELECT_TYPE)
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            switch buttonIndex {
            case 1:
                editObject[PF_TODOS_TYPE] = TO_ALL_TYPE
                editObject.removeObjectForKey(PF_TODOS_USER_LIST)
            case 2:
                editObject[PF_TODOS_TYPE] = TO_MENTORS_TYPE
                editObject.removeObjectForKey(PF_TODOS_USER_LIST)
            case 3:
                editObject[PF_TODOS_TYPE] = TO_EXEC_TYPE
                editObject.removeObjectForKey(PF_TODOS_USER_LIST)
            case 4:
                editObject[PF_TODOS_TYPE] = TO_STUDENT_REPS_TYPE
                editObject.removeObjectForKey(PF_TODOS_USER_LIST)
            case 5:
                performSegueWithIdentifier("editUserListSegue", sender: self)
            default:
                println("No new type for Todo selected")
            }
            tableView.reloadData()
        }
    }
    
    func didSelectMultipleUsers(selectedUsers: [PFUser]) {
        editObject.removeObjectForKey(PF_TODOS_USER_LIST)
        editObject[PF_TODOS_TYPE] = TO_SELECT_TYPE
        for user in selectedUsers {
            editObject.addObject(user, forKey: PF_RECORD_USER_LIST)
        }
        tableView.reloadData()
    }
    
}
