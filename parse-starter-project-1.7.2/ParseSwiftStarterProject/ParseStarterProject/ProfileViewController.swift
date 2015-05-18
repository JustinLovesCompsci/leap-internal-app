//
//  ProfileViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/10/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ProfileViewController: UITableViewController, UIActionSheetDelegate, SelectMultipleDelegate {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    let generalItems = [NAME, EMAIL, PASSWORD]
    let financialItems = [TOTAL_GAIN, TOTAL_LOSS, TOTAL_REIMBURSE, TOTAL_NET]
    
    var gains:[PFObject] = []
    var losses:[PFObject] = []
    var reimburses:[PFObject] = []
    
    var totalGains = 0
    var totalLosses = 0
    var totalReimburses = 0
    var totalNet = 0
    
    var toShowFinanceCategory = ""
    var isToCreateNewRecord = false
    var newRecord: PFObject!
    var selectedNewUsers = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.leftBarButtonItem?.enabled = false
        if Utilities.isExecUser() {
            self.navBar.leftBarButtonItem?.enabled = true
        }
        
        loadGains()
        loadLosses()
        loadReimburse()
    }
    
    @IBAction func newPressed(sender: AnyObject) {
        showNewActionSheet()
    }
    
    func didSelectMultipleUsers(selectedUsers: [PFUser]) {
        selectedNewUsers = selectedUsers
        showNewRecordSheet()
    }
    
    func showNewActionSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Post New Record", "Edit Existing Record")
        isToCreateNewRecord = false
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func showNewRecordSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "New Gain", "New Loss", "New Reimburse")
        isToCreateNewRecord = true
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            
            if isToCreateNewRecord {
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
                for user in selectedNewUsers {
                    newRecord.addObject(user, forKey: PF_RECORD_USER_LIST)
                }
                performSegueWithIdentifier("editNewRecordSegue", sender: self)
                
            } else {
                
                switch buttonIndex {
                case 1:
                    performSegueWithIdentifier("selectMultipleSegue", sender: self)
                case 2:
                    performSegueWithIdentifier("editRecordSegue", sender: self)
                default:
                    println("No record action selected")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(sender: AnyObject) {
        var logOutAlert = UIAlertController(title: "Log Out", message:"Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .Default, handler: { (action:UIAlertAction!) in
            PFUser.logOut()
            self.tabBarController?.selectedIndex = 0
        }))

        presentViewController(logOutAlert, animated: true, completion: nil)
    }
    
    func loadGains() {
        var query = PFQuery(className: PF_GAINS_CLASS_NAME)
        query.whereKey(PF_GAINS_USER_LIST, equalTo: PFUser.currentUser()!)
        query.orderByDescending(PF_GAINS_START_DATE)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.gains.removeAll(keepCapacity: false)
                if objects != nil && objects?.count > 0 {
                    self.gains.extend(objects as! [PFObject]!)
                }
                self.calculateNet()
                self.tableView.reloadData()
            } else {
                //TODO: show error
                println(error)
            }
        }
    }
    
    func loadLosses() {
        var query = PFQuery(className: PF_LOSSES_CLASS_NAME)
        query.whereKey(PF_LOSSES_USER_LIST, equalTo: PFUser.currentUser()!)
        query.orderByDescending(PF_LOSSES_START_DATE)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.losses.removeAll(keepCapacity: false)
                if objects != nil && objects?.count > 0 {
                    self.losses.extend(objects as! [PFObject]!)
                }
                self.calculateNet()
                self.tableView.reloadData()
            } else {
                //TODO: show error
                println(error)
            }
        }
    }
    
    func loadReimburse() {
        var query = PFQuery(className: PF_REIMBURSE_CLASS_NAME)
        query.whereKey(PF_REIMBURSE_USER_LIST, equalTo: PFUser.currentUser()!)
        query.orderByDescending(PF_REIMBURSE_START_DATE)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.reimburses.removeAll(keepCapacity: false)
                if objects != nil && objects?.count > 0 {
                    self.reimburses.extend(objects as! [PFObject]!)
                }
                self.calculateNet()
                self.tableView.reloadData()
            } else {
                //TODO: show error
                println(error)
            }
        }
    }
    
    func resetFinancialStats() {
        totalGains = 0
        totalLosses = 0
        totalReimburses = 0
        totalNet = 0
    }
    
    func calculateNet() {
        resetFinancialStats()
        for gain in gains {
            totalGains += gain[PF_GAINS_AMOUNT] as! Int
        }
        for loss in losses {
            totalLosses += loss[PF_LOSSES_AMOUNT] as! Int
        }
        for reimburse in reimburses {
            totalReimburses += reimburse[PF_REIMBURSE_AMOUNT] as! Int
        }
        totalNet = totalGains - totalLosses + totalReimburses
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "General"
        } else {
            return "Financial Records"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { /* General */
            return 3
        } else { /* Financials */
            return 4 //total gains, total losses, total reimburse, net
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "profileCell")
        cell.detailTextLabel?.textColor = UIColor.blackColor()
        
        if indexPath.section == 0 { /* General */
            var item = generalItems[indexPath.row]
            cell.textLabel?.text = item
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            var user:PFObject = PFUser.currentUser()!
            
            switch (item) {
            case NAME:
                if let name = user[PF_USER_NAME] as? String {
                    cell.detailTextLabel?.text = name
                }
            case EMAIL:
                if let email = user[PF_USER_EMAIL] as? String {
                    cell.detailTextLabel?.text = email
                }
            default:
                cell.detailTextLabel?.text = ""
            }
            
        } else { /* Financials */
            var item = financialItems[indexPath.row]
            cell.textLabel?.text = item
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            switch (item) {
            case TOTAL_GAIN:
                cell.detailTextLabel?.text = totalGains.description
                cell.detailTextLabel?.textColor = UIColor.greenColor() //TODO: change to dark green color
            case TOTAL_LOSS:
                cell.detailTextLabel?.text = totalLosses.description
                cell.detailTextLabel?.textColor = UIColor.redColor()
            case TOTAL_REIMBURSE:
                cell.detailTextLabel?.text = totalReimburses.description
            case TOTAL_NET:
                cell.detailTextLabel?.text = totalNet.description
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.detailTextLabel?.textColor = UIColor.blueColor()
            default:
                cell.detailTextLabel?.text = ""
            }

        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 { /* General */
            var item = generalItems[indexPath.row]
            
            switch (item) {
            case NAME:
                showAskAdminForChangeInfoDialog(NAME)
            case EMAIL:
                showAskAdminForChangeInfoDialog(EMAIL)
            case PASSWORD:
                showResetPasswordConfirmDialog()
            default:
                println("no valid general item selected")
            }
            
        } else { /* Financials */
            toShowFinanceCategory = financialItems[indexPath.row]
            if toShowFinanceCategory != TOTAL_NET {
                performSegueWithIdentifier("amountDetailSegue", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "amountDetailSegue" {
            let createVC = segue.destinationViewController as! AmountDetailViewController
            createVC.category = toShowFinanceCategory
            createVC.records.removeAll(keepCapacity: false)
            
            switch (toShowFinanceCategory) {
            case TOTAL_GAIN:
                createVC.records.extend(gains)
            case TOTAL_LOSS:
                createVC.records.extend(losses)
            case TOTAL_REIMBURSE:
                createVC.records.extend(reimburses)
            default:
               createVC.records.extend(gains)
            }
            
        } else if segue.identifier == "selectMultipleSegue" {
            let createVC = segue.destinationViewController as! SelectMultipleViewController
            createVC.delegate = self
            
        } else if segue.identifier == "editNewRecordSegue" {
            let createVC = segue.destinationViewController as! EditRecordViewController
            createVC.record = newRecord
            createVC.isEditingMode = true
        }
    }
    
    func showResetPasswordConfirmDialog(){
        var alert = UIAlertController(title: "Reset Password?", message:"You will receive an email to reset password. Your password will be encrypted.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        
        alert.addAction(UIAlertAction(title: "Reset", style: .Default, handler: { (action:UIAlertAction!) in
            PFUser.requestPasswordResetForEmailInBackground(PFUser.currentUser()!.email!)
            //TODO: display HUD to show email sent to xxx@xxx.com
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAskAdminForChangeInfoDialog(attribute:String) {
        var alert = UIAlertController(title: "Oops...", message:"Please email to admin@leap-usa.com to request changing your \(attribute.lowercaseString).", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
}