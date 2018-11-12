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
                self.performSegue(withIdentifier: "login_as_applicant", sender: self)
            }
            if error != nil { w
                print(":(")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
    }
}
