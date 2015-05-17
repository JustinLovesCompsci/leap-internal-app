//
//  SelectSingleViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/16/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import Parse
import UIKit

class SelectSingleViewController: UITableViewController, UISearchBarDelegate, UIActionSheetDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users = [PFUser]()
    var newUser: PFUser!
    var newRecord: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadUsers()
    }
    
    func loadUsers() {
        let user = PFUser.currentUser()
        var query = PFQuery(className: PF_USER_CLASS_NAME)
        query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
        query.orderByAscending(PF_USER_NAME)
        query.limit = 1000
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
    
    func searchUsers(searchName: String) {
        let user = PFUser.currentUser()
        var query = PFQuery(className: PF_USER_CLASS_NAME)
        query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
        query.whereKey(PF_USER_NAME, containsString: searchName)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("personCell", forIndexPath: indexPath) as! UITableViewCell
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user[PF_USER_NAME] as? String
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        newUser = users[indexPath.row]
        showNewRecordSheet()
    }
    
    // MARK: - UISearchBar Delegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) > 0 {
            self.searchUsers(searchText.lowercaseString)
        } else {
            self.loadUsers()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBarCancelled()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelled() {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.loadUsers()
    }
    
    //MARK: - Segue Transition
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editNewRecordSegue" {
            let createVC = segue.destinationViewController as! EditRecordViewController
            createVC.record = newRecord
        } else if segue.identifier == "editExistingRecordSegue" {
//            let createVC = segue.destinationViewController as! EditRecordViewController
        }
    }
    
    func showNewRecordSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Edit Gain", "Edit Loss", "Edit Reimburse")
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            switch buttonIndex {
            case 1:
                newRecord = PFObject(className: PF_GAINS_CLASS_NAME)
            case 2:
                newRecord = PFObject(className: PF_LOSSES_CLASS_NAME)
            case 3:
                newRecord = PFObject(className: PF_REIMBURSE_CLASS_NAME)
            default:
                println("No new type of record selected")
            }
            
            newRecord[PF_RECORD_START_DATE] = NSDate()
            newRecord[PF_RECORD_SUMMARY] = DEFAULT_RECORD_SUMMARY
            newRecord[PF_RECORD_END_DATE] = Utilities.getDueDateLimit()
            newRecord[PF_RECORD_AMOUNT] = 0
            newRecord.addObject(newUser, forKey: PF_RECORD_USER_LIST)
            
            performSegueWithIdentifier("editExistingRecordSegue", sender: self)
        }
    }
    
}