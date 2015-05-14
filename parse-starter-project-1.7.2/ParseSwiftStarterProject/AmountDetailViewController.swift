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

class AmountDetailViewController: UITableViewController {
    
    @IBOutlet weak var navBar: UINavigationItem!
    var category = ""
    var records:[PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = category
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = records[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "profileCell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = item[PF_RECORD_SUMMARY] as? String
        let amount = item[PF_RECORD_AMOUNT] as? Int
        cell.detailTextLabel?.text = amount?.description
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = records[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //TODO
    }
    
}