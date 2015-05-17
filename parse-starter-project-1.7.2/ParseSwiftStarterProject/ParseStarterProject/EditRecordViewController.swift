//
//  EditRecordViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/16/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import Parse
import UIKit

class EditRecordViewController: UITableViewController {
    
    var record:PFObject!
    let items = [RECORD_SUMMARY, RECORD_AMOUNT, RECORD_START_DATE, RECORD_END_DATE, RECORD_USER_LIST]
    var isEditingMode = false
    var toEditAttribute: String!
    
    @IBOutlet weak var saveButto: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditingMode {
            saveButto.enabled = true
        } else {
            saveButto.enabled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        //update createBy, etc.
        if !allFieldsFilled() {
            popIncorrectFieldsAlert()
        }
        let user = PFUser.currentUser()!
        record[PF_RECORD_CREATED_BY] = user[PF_USER_NAME] as? String
        record.saveEventually()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func popIncorrectFieldsAlert() {
        var alert = UIAlertController(title: "Incorrect Fields", message:"Please fill in all fields correctly", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func allFieldsFilled() -> Bool {
        if let summary = record[PF_RECORD_SUMMARY] as? String {
            let amount = record[PF_RECORD_AMOUNT] as? Int
            let startDate = record[PF_RECORD_START_DATE] as? NSDate
            let endDate = record[PF_RECORD_END_DATE] as? NSDate
            let countUsers = getNumUsers()
            
            //TODO: check logic below
            if amount == nil || startDate == nil || endDate == nil {
                return false
            }
            if count(summary) == 0 || amount <= 0 || countUsers == 0 {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    func getNumUsers() -> Int {
        if let users = record[PF_RECORD_USER_LIST] as? [PFUser] {
            return users.count
        }
        return 0
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        if isEditingMode {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        var item = items[indexPath.row]
        
        switch (item) {
        case RECORD_SUMMARY:
            cell.textLabel?.text = RECORD_SUMMARY
            cell.detailTextLabel?.text = record[PF_RECORD_SUMMARY] as? String
        case RECORD_AMOUNT:
            cell.textLabel?.text = RECORD_AMOUNT
            cell.detailTextLabel?.text = String(stringInterpolationSegment: record[PF_RECORD_AMOUNT] as! Int)
        case RECORD_START_DATE:
            cell.textLabel?.text = RECORD_START_DATE
            cell.detailTextLabel?.text = Utilities.getFormattedTextFromDate(record[PF_RECORD_START_DATE] as! NSDate)
        case RECORD_END_DATE:
            cell.textLabel?.text = RECORD_END_DATE
            cell.detailTextLabel?.text = Utilities.getFormattedTextFromDate(record[PF_RECORD_END_DATE] as! NSDate)
        case RECORD_USER_LIST:
            cell.textLabel?.text = RECORD_USER_LIST
            cell.detailTextLabel?.text = String(getNumUsers()) + " people"
        default:
            println("should not reach here")
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if isEditingMode {
            var item = items[indexPath.row]
            
            switch (item) {
            case RECORD_SUMMARY:
                toEditAttribute = PF_RECORD_SUMMARY
                performSegueWithIdentifier("editTextSegue", sender: self)
            case RECORD_AMOUNT:
                toEditAttribute = PF_RECORD_AMOUNT
                performSegueWithIdentifier("editNumSegue", sender: self)
            case RECORD_START_DATE:
                toEditAttribute = PF_RECORD_START_DATE
                performSegueWithIdentifier("editDateSegue", sender: self)
            case RECORD_END_DATE:
                toEditAttribute = PF_RECORD_END_DATE
                performSegueWithIdentifier("editDateSegue", sender: self)
            case RECORD_USER_LIST:
                toEditAttribute = PF_RECORD_USER_LIST
//                performSegueWithIdentifier("", sender: <#AnyObject?#>)
            default:
                println("should not reach here")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editTextSegue" {
            let createVC = segue.destinationViewController as! EditTextViewController
            createVC.editAttribute = toEditAttribute
            createVC.editObject = record
            createVC.objectClass = PF_GEN_TODOS_CLASS_NAME //TODO: allow exec todo as well
        } else if segue.identifier == "editNumSegue" {
            let createVC = segue.destinationViewController as! EditNumberViewController
            createVC.editAttribute = toEditAttribute
            createVC.editObject = record
            createVC.objectClass = PF_GEN_TODOS_CLASS_NAME //TODO: allow exec todo as well
        } else if segue.identifier == "editDateSegue" {
            let createVC = segue.destinationViewController as! EditDateViewController
            createVC.editAttribute = toEditAttribute
            createVC.editObject = record
            createVC.objectClass = PF_GEN_TODOS_CLASS_NAME //TODO: allow exec todo as well
        }
    }
    
}