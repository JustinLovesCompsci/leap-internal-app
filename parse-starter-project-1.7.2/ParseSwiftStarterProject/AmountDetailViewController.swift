//
//  AmountDetailViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/13/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class AmountDetailViewController: UITableViewController, DeleteRecordDelegate {
    
    @IBOutlet weak var navBar: UINavigationItem!
    var category = ""
    var records:[PFObject] = []
    var toShowRecord:PFObject!
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = category
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
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
        return records.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = records[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! RecordCell
        cell.clear()
        cell.bindDate(item)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        toShowRecord = records[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("showRecordDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecordDetailSegue" {
            let createVC = segue.destinationViewController as! EditRecordViewController
            createVC.record = toShowRecord
            createVC.isEditingMode = self.isEditingMode
            createVC.deleteDelegate = self
        }
    }
    
    // DeleteRecordDelegate
    func didDeleteRecord(record: PFObject) {
        records.removeAtIndex(find(records, record)!)
        tableView.reloadData()
    }
    
}