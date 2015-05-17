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

class EditTodoViewController: UITableViewController {
    var editObject: PFObject!
    var toEditAttribute: String!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!

    @IBAction func savePressed(sender: AnyObject) {
        editObject.saveEventually()
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        return 4
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
            cell.detailTextLabel?.text = ""
        case 2:
            cell.textLabel?.text = "Due Date"
            cell.detailTextLabel?.text = Utilities.getFormattedTextFromDate(editObject[PF_TODOS_DUE_DATE] as! NSDate)
        case 3:
            cell.textLabel?.text = "Contact Email"
            cell.detailTextLabel?.text = editObject[PF_TODOS_CREATED_BY_EMAIL] as? String
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
            performSegueWithIdentifier("editTodoTextSegue", sender: self)
        case 2:
            toEditAttribute = PF_TODOS_DUE_DATE
            performSegueWithIdentifier("editTodoDateSegue", sender: self)
        case 3:
            toEditAttribute = PF_TODOS_CREATED_BY_EMAIL
            performSegueWithIdentifier("editTodoTextSegue", sender: self)
        default:
            performSegueWithIdentifier("editTodoTextSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editTodoTextSegue" {
            let createVC = segue.destinationViewController as! EditTextViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_GEN_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
            
        } else if segue.identifier == "editTodoDateSegue" {
            let createVC = segue.destinationViewController as! EditDateViewController
            createVC.editObject = editObject
            createVC.objectClass = PF_GEN_TODOS_CLASS_NAME //TODO: allow exec as well
            createVC.editAttribute = toEditAttribute
        }
    }
    
}
