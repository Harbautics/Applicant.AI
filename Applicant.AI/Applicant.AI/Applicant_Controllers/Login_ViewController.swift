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
    
    @IBOutlet weak var accountType: UISegmentedControl!
    
    
    @IBAction func sign_up(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) {
            (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "login_as_applicant", sender: self)
            }
            if error != nil {
                print(":(")
            }
        }
    }
    @IBAction func sign_in(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) {
            (user, error) in
            if user != nil {
                // grab account type from segmented control
                // Applicant or Recruiter
                let accountType = self.accountType.titleForSegment(at: self.accountType.selectedSegmentIndex) ?? "no account type"

                // log in the user
                Login_Provider.shared.logInUser(usernameIn: self.email.text!, accountTypeIn: accountType)
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
            }
        }
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
