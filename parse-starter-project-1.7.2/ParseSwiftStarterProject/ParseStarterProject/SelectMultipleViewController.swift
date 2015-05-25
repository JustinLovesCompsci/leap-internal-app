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
    func didSelectMultipleUsers(selectedUsers: [PFUser])
}

class SelectMultipleViewController: UITableViewController {
    
    var users = [PFUser]()
    var selection = [String]()
    var selectedUsers = [PFUser]()
    
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
            
            delegate.didSelectMultipleUsers(selectedUsers)
            self.navigationController?.popViewControllerAnimated(true)
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
        if InternetUtil.isConnectedToNetwork() {
            let user = PFUser.currentUser()
            var query = PFQuery(className: PF_USER_CLASS_NAME)
            query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
            query.limit = 1000
            query.orderByAscending(PF_USER_NAME)
            
            HudUtil.showProgressHUD()
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                HudUtil.hidHUD()
                if error == nil {
                    self.users.removeAll(keepCapacity: false)
                    self.users += objects as! [PFUser]!
                    self.tableView.reloadData()
                } else {
                    HudUtil.showErrorHUD("Failed to load users")
                }
            }
        } else {
            InternetUtil.showNoInternetHUD(self)
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

}