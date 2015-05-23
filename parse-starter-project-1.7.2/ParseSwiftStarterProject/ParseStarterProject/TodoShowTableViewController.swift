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
import EventKit
import MessageUI

class TodoShowTableViewController: UITableViewController, MFMailComposeViewControllerDelegate  {
    
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func makeRowButton(item:String) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(0, 0, 150, 44)
        button.setTitle(item, forState: UIControlState.Normal)
        return button
    }
    
    func saveCalendarAction(sender: UIButton!) {
        var alert = UIAlertController(title: "Save to Calendar?", message:"This ToDo will be added to your default calendar", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{ (action:UIAlertAction!) in
        }))
            
        alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction!) in
                self.addToCalendar()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func addToCalendar() {
        if let dueDate = todo[PF_TODOS_DUE_DATE] as? NSDate {
            let eventStore = EKEventStore()
            switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
            case .Authorized:
                insertEvent(eventStore)
                break
            case .Denied:
                HudUtil.showErrorHUD("Please grant access in settings")
                break
            case .NotDetermined:
                eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
                    {[weak self] (granted: Bool, error: NSError!) -> Void in
                        if granted {
                            self!.insertEvent(eventStore)
                        } else {
                            HudUtil.showErrorHUD("Please grant access in settings")
                        }
                    })
                break
            default:
                println("Case Default")
            }
        }
    }
    
    func insertEvent(store: EKEventStore) {
        var event:EKEvent = EKEvent(eventStore: store)
        
        if let summary = todo[PF_TODOS_SUMMARY] as? String, descrip = todo[PF_TODOS_DESCRIPTION] as? String, dueDate = todo[PF_TODOS_DUE_DATE] as? NSDate, contactEmail = todo[PF_TODOS_CREATED_BY_EMAIL] as? String, contactPerson = todo[PF_TODOS_CREATED_BY_PERSON] as? String {
            event.title = "[LEAP-TODO] \(summary)"
            event.allDay = true
            event.startDate = dueDate
            event.endDate = dueDate
            event.notes = "\(descrip) \r\nPlease contact \(contactPerson) via \(contactEmail) for questions."
            event.location = "Leap Consulting Co., Ltd."
            event.calendar = store.defaultCalendarForNewEvents
            
            var error: NSError?
            let result = store.saveEvent(event, span: EKSpanThisEvent, error: &error)
            
            if result == false {
                if let theError = error {
                    println("Failed to save to calendar: \(theError.description)")
                    HudUtil.showErrorHUD("Failed")
                }
            } else {
                HudUtil.showSuccessHUD("Saved")
            }
        }
    }
    
    func askQuestionAction(sender: UIButton!) {
        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        var subject = "[Question]"
        if let summary = todo[PF_TODOS_SUMMARY] as? String {
            subject += " \(summary)"
        }
        picker.setSubject(subject)
        if let user = PFUser.currentUser(), createPerson = todo[PF_TODOS_CREATED_BY_PERSON] as? String {
            var messageBody = "Hi \(createPerson),\r\n\r\n\r\n\r\nThanks,\r\n\r\nBy \(user[PF_USER_NAME] as! String)"
            picker.setMessageBody(messageBody, isHTML: false)
        }
        if let email = todo[PF_TODOS_CREATED_BY_EMAIL] as? String {
            picker.setToRecipients([email])
        }
        picker.setEditing(true, animated: true)
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: MFMail Delegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}