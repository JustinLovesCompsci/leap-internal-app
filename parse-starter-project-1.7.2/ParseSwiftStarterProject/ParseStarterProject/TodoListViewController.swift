//
//  TodoListViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/10/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class TodoListViewController: UITableViewController, PFLogInViewControllerDelegate {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var genTodos: [PFObject]! = []
    var execTodos: [PFObject]! = []
    var toShowTodo: PFObject!
    var isRefreshing = false
    var isFirstLoading = false
    
    @IBAction func newPressed(sender: AnyObject) {
        performSegueWithIdentifier("addTodoSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "")
        refreshControl!.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        endRefreshData()
        isFirstLoading = true
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 70.0;
        
        if PFUser.currentUser() == nil || PFUser.currentUser()?.objectId == nil {
            presentLogIn()
        }
        else {
            let connected = InternetUtil.isConnectedToNetwork()
            if !connected {
                InternetUtil.showNoInternetHUD(self)
            }
            
            if isFirstLoading && connected {
                loadGenTodosFromNetwork()
                isFirstLoading = false
            } else {
                loadGenTodosFromLocal()
            }
            
            if Utilities.isExecUser() {
                navBar.rightBarButtonItem?.enabled = true
            } else {
                navBar.rightBarButtonItem?.enabled = false
            }
        }
    }
    
    func presentLogIn() {
        var logInController = MyPFLogInViewController()
        logInController.fields = (PFLogInFields.UsernameAndPassword
                                | PFLogInFields.LogInButton
                                | PFLogInFields.PasswordForgotten)
        logInController.delegate = self
        self.presentViewController(logInController, animated: true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGenTodosFromNetwork() {
        PFObject.unpinAllObjectsInBackgroundWithName(TODO_DATA_TAG) {
             (success: Bool, error: NSError?) -> Void in
//            if !success {
//                HudUtil.showErrorHUD("No local objects stored")
//                return
//            }
            
            var query = PFQuery(className: PF_GEN_TODOS_CLASS_NAME)
            query.orderByAscending(PF_GEN_TODOS_DUE_DATE)
            
            query.whereKey(PF_GEN_TODOS_DUE_DATE, greaterThanOrEqualTo: NSDate())
            query.whereKey(PF_GEN_TODOS_DUE_DATE, lessThanOrEqualTo: Utilities.getDueDateLimit())
            
            if !self.isRefreshing {
                HudUtil.showProgressHUD()
            }
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if !self.isRefreshing {
                    HudUtil.hidHUD()
                }
                if error == nil {
                    self.genTodos.removeAll(keepCapacity: false)
                    if objects != nil && objects?.count > 0 {
                        self.genTodos.extend(objects as! [PFObject]!)
                        for object in objects as! [PFObject]! {
                            object.pinInBackgroundWithName(TODO_DATA_TAG)
                        }
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
    }
    
    func loadGenTodosFromLocal() {
        var query = PFQuery(className: PF_GEN_TODOS_CLASS_NAME)
        query.orderByAscending(PF_GEN_TODOS_DUE_DATE)
        query.fromLocalDatastore()
        
        query.whereKey(PF_GEN_TODOS_DUE_DATE, greaterThanOrEqualTo: NSDate())
        query.whereKey(PF_GEN_TODOS_DUE_DATE, lessThanOrEqualTo: Utilities.getDueDateLimit())
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.genTodos.removeAll(keepCapacity: false)
                if objects != nil && objects?.count > 0 {
                    self.genTodos.extend(objects as! [PFObject]!)
                }
                self.tableView.reloadData()
            } else {
                HudUtil.showErrorHUD("Check your network settings")
                println(error)
            }
        }
    }
    
    func loadExecTodos() {
        
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "For All Mentors & Student Reps"
//    }
    
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
        return genTodos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return getGenTodoCell(indexPath)
    }
    
    func getExecTodoCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "todoCell")
        let todo:PFObject = execTodos[indexPath.row]
        cell.textLabel?.text = todo[PF_EXEC_TODOS_SUMMARY] as? String
        cell.detailTextLabel?.text = Utilities.getFormattedTextFromDate(todo[PF_EXEC_TODOS_DUE_DATE] as! NSDate)
        return cell
    }
    
    func getGenTodoCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "todoCell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let todo:PFObject = genTodos[indexPath.row]
        cell.textLabel?.text = todo[PF_GEN_TODOS_SUMMARY] as? String
        cell.detailTextLabel?.text = Utilities.getFormattedTextFromDate(todo[PF_GEN_TODOS_DUE_DATE] as! NSDate)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        toShowTodo = genTodos[indexPath.row]
        performSegueWithIdentifier("detailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let createVC = segue.destinationViewController as! TodoDetailViewController
            createVC.todo = toShowTodo
            
        } else if segue.identifier == "addTodoSegue" {
            var newTodo = PFObject(className: PF_GEN_TODOS_CLASS_NAME)
            newTodo[PF_TODOS_SUMMARY] = NEW_TODO_SUMMARY
            newTodo[PF_TODOS_DUE_DATE] = NSDate()
            let current_user:PFObject = PFUser.currentUser()!
            let user_name = current_user[PF_USER_NAME] as? String
            newTodo[PF_TODOS_CREATED_BY_PERSON] = user_name
            newTodo[PF_TODOS_CREATED_BY_EMAIL] = current_user[PF_USER_EMAIL] as? String
            
            let createVC = segue.destinationViewController as! EditTodoViewController
            createVC.editObject = newTodo
        }
    }
    
}