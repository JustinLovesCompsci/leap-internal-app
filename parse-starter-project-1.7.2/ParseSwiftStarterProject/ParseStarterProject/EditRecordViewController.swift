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
import MessageUI

class EditRecordViewController: UITableViewController, SelectMultipleDelegate, MFMailComposeViewControllerDelegate {
    
    var record:PFObject!
    let items = [RECORD_SUMMARY, RECORD_AMOUNT, RECORD_START_DATE, RECORD_END_DATE, RECORD_EMAIL, RECORD_USER_LIST]
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
        if !allFieldsFilled() {
            popIncorrectFieldsAlert()
            return
        }
        
        if !InternetUtil.isConnectedToNetwork() {
            InternetUtil.showNoInternetDialog(self)
            return
        }
        
        HudUtil.showProgressHUD()
        let user = PFUser.currentUser()!
        record[PF_RECORD_CREATED_BY] = user[PF_USER_NAME] as? String
        record.ACL = Utilities.getAllPublicACL()
        record.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            HudUtil.hidHUD()
            if success {
                self.record.pinInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if success {
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        if let error = error {
                            NSLog("%@", error)
                        }
                        HudUtil.showErrorHUD("Cannot save to phone")
                    }
                }
            } else {
                if let error = error {
                    NSLog("%@", error)
                }
                HudUtil.showErrorHUD("Check your network settings")
            }
        }
    }
    
    func popIncorrectFieldsAlert() {
        var alert = UIAlertController(title: "Incorrect Fields", message:"Please fill in all fields correctly", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func allFieldsFilled() -> Bool {
        if let summary = record[PF_RECORD_SUMMARY] as? String, startDate = record[PF_RECORD_START_DATE] as? NSDate,  endDate = record[PF_RECORD_END_DATE] as? NSDate, amount = record[PF_RECORD_AMOUNT] as? Int {
            
            let countUsers = getNumUsers()
            if count(summary) == 0 || amount <= 0 || countUsers <= 0 {
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
            if isEditingMode {
                cell.textLabel?.text = RECORD_USER_LIST
                cell.detailTextLabel?.text = String(getNumUsers()) + " people"
            } else {
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                let button = makeRowButton("Ask a Question")
                button.addTarget(self, action: "askQuestionAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.addSubview(button)
                button.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2)
            }
        case RECORD_EMAIL:
            cell.textLabel?.text = RECORD_EMAIL
            cell.detailTextLabel?.text = record[PF_RECORD_CONTACT_EMAIL] as? String
        default:
            println("should not reach here")
        }
        
        return cell
    }
    
    func makeRowButton(item:String) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(0, 0, 150, 44)
        button.setTitle(item, forState: UIControlState.Normal)
        return button
    }
    
    func askQuestionAction(sender: UIButton!) {
        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        var subject = QUESTION_EMAIL_TAG
        if let summary = record[PF_RECORD_SUMMARY] as? String {
            subject += " \(summary)"
        }
        picker.setSubject(subject)
        if let user = PFUser.currentUser(), createPerson = record[PF_RECORD_CREATED_BY] as? String {
            var messageBody = "Hi \(createPerson),\r\n\r\n\r\n\r\nThanks,\r\n\r\n\(user[PF_USER_NAME] as! String)"
            picker.setMessageBody(messageBody, isHTML: false)
        }
        if let email = record[PF_RECORD_CONTACT_EMAIL] as? String {
            picker.setToRecipients([email])
        }
        picker.setEditing(true, animated: true)
        presentViewController(picker, animated: true, completion: nil)
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
                performSegueWithIdentifier("editDateChoiceSegue", sender: self)
            case RECORD_USER_LIST:
                toEditAttribute = PF_RECORD_USER_LIST
                performSegueWithIdentifier("editRecipientSegue", sender: self)
            case RECORD_EMAIL:
                toEditAttribute = PF_RECORD_CONTACT_EMAIL
                performSegueWithIdentifier("editChoiceSegue", sender: self)
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
            createVC.objectClass = PF_TODOS_CLASS_NAME //TODO: allow exec todo as well
        } else if segue.identifier == "editNumSegue" {
            let createVC = segue.destinationViewController as! EditNumberViewController
            createVC.editAttribute = toEditAttribute
            createVC.editObject = record
            createVC.objectClass = PF_TODOS_CLASS_NAME //TODO: allow exec todo as well
        } else if segue.identifier == "editDateSegue" {
            let createVC = segue.destinationViewController as! EditDateViewController
            createVC.editAttribute = toEditAttribute
            createVC.editObject = record
            createVC.objectClass = PF_TODOS_CLASS_NAME //TODO: allow exec todo as well
        } else if segue.identifier == "editRecipientSegue" {
            let createVC = segue.destinationViewController as! SelectMultipleViewController
            createVC.delegate = self
            if let recipients = record[PF_TODOS_USER_LIST] as? [PFUser] {
                for recipient in recipients {
                    createVC.selection.append(recipient.objectId!)
                }
            }
        } else if segue.identifier == "editChoiceSegue" {
            let createVC = segue.destinationViewController as! EditChoiceViewController
            createVC.editAttribute = toEditAttribute
            createVC.editObject = record
            createVC.objectClass = PF_TODOS_CLASS_NAME //TODO: allow exec todo as well
            createVC.items += Utilities.getEmailItems()
        } else if segue.identifier == "editDateChoiceSegue" {
            let createVC = segue.destinationViewController as! EditDateChoiceViewController
            createVC.editAttribute = toEditAttribute
            createVC.editObject = record
            createVC.objectClass = PF_TODOS_CLASS_NAME //TODO: allow exec todo as well
            let currentComps = FinanceUtil.getCurrentComponents()
            createVC.items.append(FinanceUtil.getCurrentFinancialPeriodDate(currentComps))
            createVC.items.append(FinanceUtil.getNextFinancialPeriodDate(currentComps))
            createVC.items.append(FinanceUtil.getFurtherFinancialPeriodDate(currentComps))
        }
    }
    
    func didSelectMultipleUsers(selectedUsers: [PFUser]) {
        record.removeObjectForKey(PF_RECORD_USER_LIST)
        for user in selectedUsers {
            record.addObject(user, forKey: PF_RECORD_USER_LIST)
        }
        tableView.reloadData()
    }
    
    // MARK: MFMail Delegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}