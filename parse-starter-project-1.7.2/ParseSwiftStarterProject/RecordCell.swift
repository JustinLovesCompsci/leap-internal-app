//
//  RecordCell.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/17/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class RecordCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var summaryField: UILabel!
    @IBOutlet weak var dateRangeField: UILabel!
    @IBOutlet weak var amountField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindDate(record: PFObject) {
        summaryField.text = record[PF_RECORD_SUMMARY] as? String
        if let startDate = record[PF_RECORD_START_DATE] as? NSDate, endDate = record[PF_RECORD_END_DATE] as? NSDate {
            var startDateText = Utilities.getFormattedTextFromDate(startDate)
            var endDateText = Utilities.getFormattedTextFromDate(endDate)
            var dateRangeText = startDateText + " - " + endDateText
            dateRangeField.text = dateRangeText
        } else {
            dateRangeField.text = ""
        }
        let amount = record[PF_RECORD_AMOUNT] as? Int
        amountField.text = amount?.description
    }
    
    func clear() {
        summaryField.text = ""
        dateRangeField.text = ""
        amountField.text = ""
    }
    
}
