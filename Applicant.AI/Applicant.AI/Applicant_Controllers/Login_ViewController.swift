//
//  Login_ViewController.swift
//  Applicant.AI
//
//  Created by Troy Stacer on 11/11/18.d
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class Login_ViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var accountType: UISegmentedControl!
    
    
    @IBAction func sign_up(_ sender: Any) {
        if checkAll() {
            Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) {
                (user, error) in
                if user != nil {
                    
                    let jsonObject: [String: String] = [
                        "name": self.fullName.text!,
                        "email": self.email.text!,
                        "password": self.password.text!
                    ]
                    let accountType = self.accountType.titleForSegment(at: self.accountType.selectedSegmentIndex) ?? "no account type"
                    Login_Provider.shared.logInUser(usernameIn: self.email.text!, accountTypeIn: accountType, nameIn: self.fullName.text!)
                    
                    RecruiterAPIManager.createUser(data: jsonObject, completionHandler: { (json) in
                        print("Create User returns:\n", json)
                    })
                    
                    // segue to applicant
                    if accountType == "Applicant" {
                        self.performSegue(withIdentifier: "login_as_applicant", sender: self)
                    }
                        // segue to recruiter
                    else {
                        self.performSegue(withIdentifier: "login_as_recruiter", sender: self)
                    }
                    
                    
                }
                if error != nil {
                    print(":(")
                    self.showErrorAlert()
                }
            }
        }
    }
    @IBAction func sign_in(_ sender: Any) {
        if checkAll() {
            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) {
                (user, error) in
                if user != nil {
                    // grab account type from segmented control
                    // Applicant or Recruiter
                    let accountType = self.accountType.titleForSegment(at: self.accountType.selectedSegmentIndex) ?? "no account type"
                    
                    // log in the user
                    Login_Provider.shared.logInUser(usernameIn: self.email.text!, accountTypeIn: accountType, nameIn: self.fullName.text!)
                    // segue
                    
                    // segue to applicant
                    if accountType == "Applicant" {
                        self.performSegue(withIdentifier: "login_as_applicant", sender: self)
                    }
                        // segue to recruiter
                    else {
                        self.performSegue(withIdentifier: "login_as_recruiter", sender: self)
                    }
                    
                    
                    //self.performSegue(withIdentifier: "login_as_applicant", sender: self)
                }
                if error != nil {
                    print(":(")
                    self.showErrorAlert()
                }
            }
        }
    }
    
    func checkAll() -> Bool {
        var missing = [String]()
        var allPass = true
        if self.email.text == "" {
            missing.append("email")
            allPass = false
        }
        if self.password.text == "" {
            missing.append("password")
            allPass = false
        }
        if self.fullName.text == "" {
            missing.append("name")
            allPass = false
        }
        
        if (allPass) {
            return true
        }
        else {
            showMissingFields(missing: missing)
            return false
        }
    }
    
    func showMissingFields(missing: [String]) {
        var message = "Missing Fields: "
        for item in missing {
            message += "\(item)"
        }
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Please Fill Out All Fields", message: message, preferredStyle: .alert)
        
        // 2. Add action to clear alert
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
        }))
        
        // 3. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Error", message: "Invalid email or username", preferredStyle: .alert)
        
        // 2. Add action to clear alert
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
        }))
        
        // 3. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        // In AppDelegat.swift:
        // checking to see if user is logged in, if so passing through 

        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
    }
}
