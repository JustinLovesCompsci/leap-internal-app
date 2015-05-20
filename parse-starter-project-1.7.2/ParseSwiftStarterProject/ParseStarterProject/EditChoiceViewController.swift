//
//  EditChoiceViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/19/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var editObject: PFObject!
    var objectClass: String!
    var editAttribute: String!
    var items = [String]()
    var selectedAttribute: String!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBAction func donePressed(sender: AnyObject) {
        editObject[editAttribute] = selectedAttribute
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pickerView.selectRow(DEFAULT_SELECTED_ROW, inComponent: 0, animated: true)
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
        return items[row]
    }
}