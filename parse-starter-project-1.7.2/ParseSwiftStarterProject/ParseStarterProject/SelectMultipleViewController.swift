//
//  SelectMultipleViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/16/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import Parse
import UIKit

protocol SelectMultipleDelegate {
    func didSelectMultipleUsers(record: PFObject)
}

class SelectMultipleViewController: UITableViewController, UIActionSheetDelegate {
    
    var users = [PFUser]()
    var selection = [String]()
    var selectedUsers = [PFUser]()
    var record: PFObject!
    var isNewRecord = false
    
    var delegate: SelectMultipleDelegate!
    
    @IBAction func donePressed(sender: AnyObject) {
        if selection.count == 0 {
            popNonSelectedDialog()
        } else {
            selectedUsers = [PFUser]()
            for user in users {
                if contains(selection, user.objectId!) {
                    selectedUsers.append(user)
                }
            }
            if isNewRecord {
                showNewRecordSheet()
            } else {
                addSelectedUsersToRecord()
                delegate.didSelectMultipleUsers(record)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    func popNonSelectedDialog() {
        var alert = UIAlertController(title: "None selected", message:"You must select at least one to proceed", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
    }
    
    func loadUsers() {
        let user = PFUser.currentUser()
        var query = PFQuery(className: PF_USER_CLASS_NAME)
        query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
        query.limit = 1000
        query.orderByAscending(PF_USER_NAME)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users.removeAll(keepCapacity: false)
                self.users += objects as! [PFUser]!
                self.tableView.reloadData()
            } else {
                //TODO: hud
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user[PF_USER_NAME] as? String
        
        let selected = contains(selection, user.objectId!)
        cell.accessoryType = selected ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let user = users[indexPath.row]
        let selected = contains(selection, user.objectId!)
        if selected {
            if let index = find(selection, user.objectId!) {
                selection.removeAtIndex(index)
            }
        } else {
            selection.append(user.objectId!)
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: - Segue Transition
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editNewRecordSegue" {
            let createVC = segue.destinationViewController as! EditRecordViewController
            createVC.record = record
            createVC.isEditingMode = true
        }
    }
    
    func showNewRecordSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "New Gain", "New Loss", "New Reimburse")
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            
            switch buttonIndex {
            case 1:
                record = PFObject(className: PF_GAINS_CLASS_NAME)
            case 2:
                record = PFObject(className: PF_LOSSES_CLASS_NAME)
            case 3:
                record = PFObject(className: PF_REIMBURSE_CLASS_NAME)
            default:
                println("No new type of record selected")
            }
            
            record[PF_RECORD_START_DATE] = NSDate()
            record[PF_RECORD_SUMMARY] = DEFAULT_RECORD_SUMMARY
            record[PF_RECORD_END_DATE] = Utilities.getDueDateLimit()
            record[PF_RECORD_AMOUNT] = 0
            addSelectedUsersToRecord()
            
            performSegueWithIdentifier("editNewRecordSegue", sender: self)
        }
    }
    
    func addSelectedUsersToRecord() {
        if !isNewRecord {
            record.removeObjectForKey(PF_RECORD_USER_LIST)
        }
        for user in selectedUsers {
            record.addObject(user, forKey: PF_RECORD_USER_LIST)
        }
    }

}