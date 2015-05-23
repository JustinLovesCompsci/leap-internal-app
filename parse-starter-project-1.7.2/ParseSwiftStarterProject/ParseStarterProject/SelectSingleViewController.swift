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

protocol SelectSingleDelegate {
    func didSelectSingleUser(user: PFUser)
}

class SelectSingleViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users = [PFUser]()
    var selectedUser: PFUser!
    var delegate: SelectSingleDelegate!
    
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
    }
    
    func searchUsers(searchName: String) {
        let user = PFUser.currentUser()
        var query = PFQuery(className: PF_USER_CLASS_NAME)
        query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
        query.whereKey(PF_USER_NAME_LOWER_CASE, containsString: searchName.lowercaseString)
        query.orderByAscending(PF_USER_NAME)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users.removeAll(keepCapacity: false)
                self.users += objects as! [PFUser]!
                self.tableView.reloadData()
            } else {
                // do nothing
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
        delegate.didSelectSingleUser(users[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - UISearchBar Delegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) > 0 {
            searchUsers(searchText.lowercaseString)
        } else {
            loadUsers()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarCancelled()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelled() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        loadUsers()
    }
    
}