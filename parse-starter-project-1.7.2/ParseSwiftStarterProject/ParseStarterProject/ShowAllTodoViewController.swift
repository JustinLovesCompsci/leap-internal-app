//
//  ShowAllTodoViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 6/2/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import Parse
import UIKit

class ShowAllTodoViewController: UITableViewController {
    
    var todos: [PFObject]! = []
    var toShowTodo: PFObject!
    var isRefreshing = false
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "")
        refreshControl!.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        endRefreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = PFUser.currentUser() {
            let connected = InternetUtil.isConnectedToNetwork()
            if connected {
                navBar.title = "All ToDo"
                loadGenTodosFromNetwork()
            } else {
                navBar.title = "All ToDo(未连接)"
            }
        }
    }
    
    func refreshData(sender: AnyObject) {
        if InternetUtil.isConnectedToNetwork() {
            isRefreshing = true
            loadGenTodosFromNetwork()
        } else {
            InternetUtil.showNoInternetDialog(self)
            endRefreshData()
        }
    }
    
    func endRefreshData() {
        isRefreshing = false
        refreshControl?.endRefreshing()
    }
    
    func loadGenTodosFromNetwork() {
        if !self.isRefreshing {
            HudUtil.showProgressHUD()
        }
        
            var query = PFQuery(className: PF_TODOS_CLASS_NAME)
            query.whereKey(PF_TODOS_DUE_DATE, greaterThanOrEqualTo: NSDate())
            query.whereKey(PF_TODOS_DUE_DATE, lessThanOrEqualTo: Utilities.getDueDateLimit())
            query.orderByAscending(PF_TODOS_DUE_DATE)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if !self.isRefreshing {
                    HudUtil.hidHUD()
                }
                if error == nil {
                    self.todos.removeAll(keepCapacity: false)
                    if objects != nil && objects?.count > 0 {
                        self.todos.extend(objects as! [PFObject]!)
                    }
                    self.tableView.reloadData()
                } else {
                    HudUtil.showErrorHUD("Check your network settings")
                    println(error)
                }
                
                if self.isRefreshing {
                    self.endRefreshData()
                }
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
        return todos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let todo:PFObject = todos[indexPath.row]
        cell.textLabel?.text = todo[PF_TODOS_SUMMARY] as? String
        cell.detailTextLabel?.text = Utilities.getFormattedTextFromDate(todo[PF_TODOS_DUE_DATE] as! NSDate)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        toShowTodo = todos[indexPath.row]
        performSegueWithIdentifier("detailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let createVC = segue.destinationViewController as! TodoDetailViewController
            createVC.todo = toShowTodo
        }
    }
    
}