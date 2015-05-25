//
//  EditDateChoiceViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/25/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditDateChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var editObject: PFObject!
    var objectClass: String!
    var editAttribute: String!
    var items = [NSDate]()
    var selectedAttribute: NSDate!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBAction func donePressed(sender: AnyObject) {
        editObject[editAttribute] = selectedAttribute
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedAttribute = editObject[editAttribute] as? NSDate
        var selectedIndex = 0
        var currentIndex = 0
        for item in items {
            if Utilities.isSameAsDate(item, dateTo: selectedAttribute) {
                selectedIndex = currentIndex
                break
            }
            currentIndex += 1
        }
        
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedAttribute = items[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Utilities.getLongTextFromDate(items[row])
    }
    
}