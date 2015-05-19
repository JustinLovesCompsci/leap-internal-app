//
//  TodoShowTableViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/18/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import Parse
import UIKit

class TodoShowTableViewController: UITableViewController {
    
    var todo: PFObject!
    let items = [PF_TODOS_SUMMARY, PF_TODOS_DUE_DATE, PF_TODOS_CREATED_BY_PERSON, PF_TODOS_CREATED_BY_EMAIL, SAVE_TO_CALENDAR, ASK_QUESTION]
    let displayTexts = [TODOS_DISPLAY_SUMMARY, TODOS_DISPLAY_DUE_DATE, TODOS_DISPLAY_CREATED_PERSON, TODOS_DISPLAY_CONTACT_EMAIL]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
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
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        
        switch (item) {
        case SAVE_TO_CALENDAR:
            let button = makeRowButton(item)
            button.addTarget(self, action: "saveCalendarAction:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(button)
            button.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2)
        case ASK_QUESTION:
            let button = makeRowButton(item)
            button.addTarget(self, action: "askQuestionAction:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(button)
            button.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2)
        default:
            cell.textLabel?.text = displayTexts[indexPath.row]
            if item == PF_TODOS_DUE_DATE {
                if let date = todo[PF_TODOS_DUE_DATE] as? NSDate {
                    cell.detailTextLabel?.text = Utilities.getFormattedTextFromDate(date)
                } else {
                    cell.detailTextLabel?.text = ""
                }
            } else {
                if let detail = todo[item] as? String {
                    cell.detailTextLabel?.text = detail
                } else {
                    cell.detailTextLabel?.text = ""
                }
            }
        }

        return cell
    }
    
    func makeRowButton(item:String) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(0, 0, 150, 44)
        button.setTitle(item, forState: UIControlState.Normal)
        return button
    }
    
    func saveCalendarAction(sender: UIButton!) {
        println("save to calendar called")
    }
    
    func askQuestionAction(sender: UIButton!) {
        println("ask questions called")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}