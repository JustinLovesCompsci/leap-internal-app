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

class ProfileViewController: UITableViewController, UIActionSheetDelegate, SelectMultipleDelegate, SelectSingleDelegate {
    
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
    var isToEditRecord = false
    var isToCreateRecord = false
    
    var isRefreshing = false
    
    //SelectMultipleDelegate
    var newRecord: PFObject!
    var selectedNewUsers = [PFUser]()
    
    //SelectSingleDelegate
    var selectedUser: PFUser!
    var records: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "")
        refreshControl!.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        endRefreshData()
        if InternetUtil.isConnectedToNetwork() {
            loadDataFromNetwork()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navBar.leftBarButtonItem?.enabled = false
        if Utilities.isExecUser() {
            self.navBar.leftBarButtonItem?.enabled = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if InternetUtil.isConnectedToNetwork() {
            navBar.title = "Profile"
        } else {
            navBar.title = "Profile(未连接)"
        }
        
        loadRecords(true)
    }
    
    func refreshData(sender: AnyObject) {
        if InternetUtil.isConnectedToNetwork() {
            isRefreshing = true
            loadDataFromNetwork()
        } else {
            endRefreshData()
            InternetUtil.showNoInternetDialog(self)
        }
    }
    
    func loadDataFromNetwork() {
        PFObject.unpinAllObjectsInBackgroundWithName(MY_RECORDS_TAG) {
            (success: Bool, error: NSError?) -> Void in
            if !self.isRefreshing {
                HudUtil.showProgressHUD()
            }
            self.loadRecords(false)
            if !self.isRefreshing {
                HudUtil.hidHUD()
            }
        }
    }
    
    func endRefreshData() {
        isRefreshing = false
        refreshControl?.endRefreshing()
    }
    
    @IBAction func newPressed(sender: AnyObject) {
        showNewActionSheet()
    }
    
    func didSelectMultipleUsers(selectedUsers: [PFUser]) {
        selectedNewUsers = selectedUsers
        showNewRecordSheet()
    }
    
    func didSelectSingleUser(user: PFUser) {
        selectedUser = user
        showEditRecordSheet()
    }
    
    func showNewActionSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Post New Record", "Edit Existing Record")
        isToEditRecord  = false
        isToCreateRecord = false
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func showNewRecordSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "New Gain", "New Loss", "New Reimburse")
        isToEditRecord  = true
        isToCreateRecord = true
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func showEditRecordSheet() {
        var actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Edit Gain", "Edit Loss", "Edit Reimburse")
        isToEditRecord = true
        isToCreateRecord = false
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func isToAddNewRecord() -> Bool {
        return isToEditRecord && isToCreateRecord
    }
    
    func isToEditOtherRecords() -> Bool {
        return isToEditRecord && !isToCreateRecord
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            
            if isToEditRecord {
                
                newRecord = PFObject(className: PF_RECORD_CLASS_NAME)
                if isToCreateRecord {
                    switch buttonIndex {
                    case 1:
                        newRecord[PF_RECORD_TYPE] = GAIN_RECORD_TYPE
                    case 2:
                        newRecord[PF_RECORD_TYPE] = LOSS_RECORD_TYPE
                    case 3:
                        newRecord[PF_RECORD_TYPE] = REIMBURSE_RECORD_TYPE
                    default:
                        println("No new type of record selected")
                    }
                    
                    newRecord[PF_RECORD_START_DATE] = NSDate()
                    newRecord[PF_RECORD_SUMMARY] = DEFAULT_RECORD_SUMMARY
                    newRecord[PF_RECORD_END_DATE] = FinanceUtil.getCurrentFinancialPeriodDate(FinanceUtil.getCurrentComponents())
                    newRecord[PF_RECORD_AMOUNT] = 0
                    let user = PFUser.currentUser()!
                    newRecord[PF_RECORD_CONTACT_EMAIL] = user.email
                    for user in selectedNewUsers {
                        newRecord.addObject(user, forKey: PF_RECORD_USER_LIST)
                    }
                    performSegueWithIdentifier("editNewRecordSegue", sender: self)
                    
                } else {
                    switch buttonIndex {
                    case 1:
                        toShowFinanceCategory = TOTAL_GAIN
                    case 2:
                        toShowFinanceCategory = TOTAL_LOSS
                    case 3:
                        toShowFinanceCategory = TOTAL_REIMBURSE
                    default:
                        println("No new type of record selected")
                    }
                    
                    loadSelectUserRecords()
                }
                
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
            PushNotication.uninstallUserForPush()
            self.tabBarController?.selectedIndex = 0
        }))

        presentViewController(logOutAlert, animated: true, completion: nil)
    }
    
    func loadRecords(fromLocal: Bool) {
        var query = PFQuery(className: PF_RECORD_CLASS_NAME)
        if fromLocal {
            query.fromLocalDatastore()
        }
        query.whereKey(PF_RECORD_USER_LIST, equalTo: PFUser.currentUser()!)
        query.orderByDescending(PF_RECORD_START_DATE)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.gains.removeAll(keepCapacity: false)
                self.losses.removeAll(keepCapacity: false)
                self.reimburses.removeAll(keepCapacity: false)
                
                if objects != nil && objects?.count > 0 {
                    for object in objects as! [PFObject]! {
                        switch (object[PF_RECORD_TYPE] as! String) {
                        case GAIN_RECORD_TYPE:
                            self.gains.append(object)
                        case LOSS_RECORD_TYPE:
                            self.losses.append(object)
                        case REIMBURSE_RECORD_TYPE:
                            self.reimburses.append(object)
                        default:
                            println("should not reach here")
                        }
                        
                        object.pinInBackgroundWithName(MY_RECORDS_TAG)
                    }
                }
                self.calculateNet()
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
    
    func resetFinancialStats() {
        totalGains = 0
        totalLosses = 0
        totalReimburses = 0
        totalNet = 0
    }
    
    func calculateNet() {
        resetFinancialStats()
        for gain in gains {
            totalGains += gain[PF_RECORD_AMOUNT] as! Int
        }
        for loss in losses {
            totalLosses += loss[PF_RECORD_AMOUNT] as! Int
        }
        for reimburse in reimburses {
            totalReimburses += reimburse[PF_RECORD_AMOUNT] as! Int
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
            
            if isToEditOtherRecords() {
                createVC.records.extend(records)
                createVC.isEditingMode = true
                
            } else {
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
            }
            
        } else if segue.identifier == "selectMultipleSegue" {
            let createVC = segue.destinationViewController as! SelectMultipleViewController
            createVC.delegate = self
            
        } else if segue.identifier == "editNewRecordSegue" {
            let createVC = segue.destinationViewController as! EditRecordViewController
            createVC.record = newRecord
            createVC.isEditingMode = true
            
        } else if segue.identifier == "editRecordSegue" {
            let createVC = segue.destinationViewController as! SelectSingleViewController
            createVC.delegate = self
            
        }
        resetEditÇreateMode()
    }
    
    func resetEditÇreateMode() {
        isToEditRecord = false
        isToCreateRecord = false
    }
    
    func loadSelectUserRecords() {
        var query = PFQuery(className: PF_RECORD_CLASS_NAME)
        
        switch (toShowFinanceCategory) {
        case TOTAL_GAIN:
            query.whereKey(PF_RECORD_TYPE, equalTo: GAIN_RECORD_TYPE)
        case TOTAL_LOSS:
            query.whereKey(PF_RECORD_TYPE, equalTo: LOSS_RECORD_TYPE)
        case TOTAL_REIMBURSE:
            query.whereKey(PF_RECORD_TYPE, equalTo: REIMBURSE_RECORD_TYPE)
        default:
            println("should not reach here")
        }

        HudUtil.showProgressHUD()
        query.whereKey(PF_RECORD_USER_LIST, equalTo: selectedUser)
        query.orderByDescending(PF_RECORD_START_DATE)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            HudUtil.hidHUD()
            if error == nil {
                self.records.removeAll(keepCapacity: false)
                if objects != nil && objects?.count > 0 {
                    self.records.extend(objects as! [PFObject]!)
                }
                self.performSegueWithIdentifier("amountDetailSegue", sender: self)
            } else {
                HudUtil.showErrorHUD("Failed to load records")
                println(error)
            }
        }
    }
    
    func showResetPasswordConfirmDialog(){
        var alert = UIAlertController(title: "Reset Password?", message:"You will receive an email to reset password. Your password will be encrypted.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
        
        alert.addAction(UIAlertAction(title: "Reset", style: .Default, handler: { (action:UIAlertAction!) in
            if let userEmail = PFUser.currentUser()?.email {
                PFUser.requestPasswordResetForEmailInBackground(userEmail)
                HudUtil.showSuccessHUD("Email sent to \(userEmail)")
            }
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