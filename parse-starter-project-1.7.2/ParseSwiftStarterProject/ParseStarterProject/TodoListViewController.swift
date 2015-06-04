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
    
    let EXEC_TODO_TYPES = [TO_ALL_TYPE, TO_EXEC_TYPE]
    let MENTORS_TODO_TYPES = [TO_ALL_TYPE, TO_EXEC_TYPE]
    let STUDENT_REPS_TODO_TYPES = [TO_ALL_TYPE, TO_STUDENT_REPS_TYPE]
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var genTodos: [PFObject]! = []
    var toShowTodo: PFObject!
    var isRefreshing = false
    var isFirstLoading = false
    var isPresentingLogIn = false
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
        
        if let user = PFUser.currentUser() {
            PushNotication.installUserForPush()

            if Utilities.isExecUser() {
                navBar.rightBarButtonItem?.enabled = true
            } else {
                navBar.rightBarButtonItem?.enabled = false
            }
        }
        else {
            presentLogIn()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isPresentingLogIn {
            return
        } else {
            loadViewContent()
        }
    }
    
    func loadViewContent() {
        if let user = PFUser.currentUser() {
            let connected = InternetUtil.isConnectedToNetwork()
            if connected {
                navBar.title = "Ur ToDo"
            } else {
                navBar.title = "Ur ToDo(未连接)"
            }
            
            if isFirstLoading && connected {
                loadGenTodosFromNetwork()
                isFirstLoading = false
            } else {
                loadGenTodosFromLocal()
            }
        }
    }
    
    func presentLogIn() {
        var logInController = MyPFLogInViewController()
        logInController.fields = (PFLogInFields.UsernameAndPassword
            | PFLogInFields.LogInButton
            | PFLogInFields.PasswordForgotten)
        logInController.delegate = self
        isPresentingLogIn = true
        self.presentViewController(logInController, animated: true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        isPresentingLogIn = false
        loadViewContent()
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
            
            var typeQuery = PFQuery(className: PF_TODOS_CLASS_NAME)
            typeQuery.whereKey(PF_TODOS_DUE_DATE, greaterThanOrEqualTo: NSDate())
            typeQuery.whereKey(PF_TODOS_DUE_DATE, lessThanOrEqualTo: Utilities.getDueDateLimit())
            
            if Utilities.isExecUser() {
                typeQuery.whereKey(PF_TODOS_TYPE, containedIn: self.EXEC_TODO_TYPES)
            } else if Utilities.isMentorUser() {
                typeQuery.whereKey(PF_TODOS_TYPE, containedIn: self.MENTORS_TODO_TYPES)
            } else if Utilities.isStudentRepUser() {
                typeQuery.whereKey(PF_TODOS_TYPE, containedIn: self.STUDENT_REPS_TODO_TYPES)
            }
            
            if !self.isRefreshing {
                HudUtil.showProgressHUD()
            }
            
            let user = PFUser.currentUser()!
            
            var selectQuery = PFQuery(className: PF_TODOS_CLASS_NAME)
            selectQuery.whereKey(PF_TODOS_DUE_DATE, greaterThanOrEqualTo: NSDate())
            selectQuery.whereKey(PF_TODOS_DUE_DATE, lessThanOrEqualTo: Utilities.getDueDateLimit())
            selectQuery.whereKey(PF_TODOS_USER_LIST, equalTo: user)

            var query = PFQuery.orQueryWithSubqueries([typeQuery, selectQuery])
            query.orderByAscending(PF_TODOS_DUE_DATE)
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
        var query = PFQuery(className: PF_TODOS_CLASS_NAME)
        query.orderByAscending(PF_TODOS_DUE_DATE)
        query.fromLocalDatastore()
        
        query.whereKey(PF_TODOS_DUE_DATE, greaterThanOrEqualTo: NSDate())
        query.whereKey(PF_TODOS_DUE_DATE, lessThanOrEqualTo: Utilities.getDueDateLimit())
        
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
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if !InternetUtil.isConnectedToNetwork() {
//            return "No Internet is available"
//        }
//        return nil
//    }
//    
//    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if !InternetUtil.isConnectedToNetwork() {
//            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
//            header.contentView.backgroundColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0) //make the background color light blue
//            header.textLabel.textColor = UIColor.whiteColor() //make the text white
//            header.alpha = 0.5 //make the header transparent
//        }
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
    
    func getGenTodoCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "todoCell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let todo:PFObject = genTodos[indexPath.row]
        cell.textLabel?.text = todo[PF_TODOS_SUMMARY] as? String
        cell.detailTextLabel?.text = Utilities.getFormattedTextFromDate(todo[PF_TODOS_DUE_DATE] as! NSDate)
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
            var newTodo = PFObject(className: PF_TODOS_CLASS_NAME)
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