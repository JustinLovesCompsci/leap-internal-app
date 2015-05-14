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

class TodoListViewController: UITableViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var genTodos: [PFObject]! = []
    var execTodos: [PFObject]! = []
    var toShowTodo: PFObject!
    
    @IBAction func newPressed(sender: AnyObject) {
        showNewActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Utilities.isExecUser() {
            println ("current user is Exec")
            self.navBar.rightBarButtonItem?.enabled = true
        } else {
            println ("current user is not Exec")
            self.navBar.rightBarButtonItem?.enabled = false
        }
    }
    
    func showNewActionSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Post New Todo", "Edit Existing Todo")
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
//            switch buttonIndex {
//            
//            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 70.0;
        
        if PFUser.currentUser() == nil || PFUser.currentUser()?.objectId == nil {
            Utilities.loginUser(self)
        }
        else {
            if Utilities.isExecUser() {
                loadExecTodos()
            }
            loadGenTodos()
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGenTodos() {
        var query = PFQuery(className: PF_GEN_TODOS_CLASS_NAME)
        query.orderByAscending(PF_GEN_TODOS_DUE_DATE)
        //TODO: check below logic
        query.whereKey(PF_GEN_TODOS_DUE_DATE, greaterThanOrEqualTo: NSDate())
        query.whereKey(PF_GEN_TODOS_DUE_DATE, lessThanOrEqualTo: Utilities.getDueDateLimit())

        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.genTodos.removeAll(keepCapacity: false)
                self.genTodos.extend(objects as! [PFObject]!)
                self.tableView.reloadData()
            } else {
                //TODO: show error
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
        }
    }
    
}