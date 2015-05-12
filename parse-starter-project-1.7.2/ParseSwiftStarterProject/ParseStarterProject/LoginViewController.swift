//
//  LoginViewController.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/10/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField! {
        didSet { self.emailField.delegate = self }
    }
    @IBOutlet weak var passwordField: UITextField! {
        didSet { self.passwordField.delegate = self }
    }
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginPressed(sender: AnyObject) {
        login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        self.tableView?.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.emailField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            login()
        }
        return true
    }
    
    func login() {
        let email = emailField.text
        let password = passwordField.text
        
        if count(email) == 0 {
            //TODO: HUD
            return
        }
        if count (password) == 0 {
            //TODO: HUD
            return
        }
        
        PFUser.logInWithUsernameInBackground(email, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                if let info = error!.userInfo {
                    //TODO: HUD
                }
            }
        }
    }
    
}