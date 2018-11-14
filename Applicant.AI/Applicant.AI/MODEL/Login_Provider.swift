//
//  Login_Provider.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/12/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

class Login_Provider {
    // Properties
    
    var username = String()
    var accountType = String()
    
    let defaults = UserDefaults.standard
    
    static let shared = Login_Provider()
    
    private init() {
        self.username = self.defaults.object(forKey: "username") as? String ?? "no user"
        
        self.accountType = self.defaults.object(forKey: "accountType") as? String ?? "no account type"
        
        // notification
        let notificationName = NSNotification.Name("userFound")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func logInUser(usernameIn: String, accountTypeIn: String) {
        self.username = usernameIn
        let encodedData = usernameIn
        self.defaults.set(encodedData, forKey: "username")
        
        self.accountType = accountTypeIn
        let encodedData2 = accountTypeIn
        self.defaults.set(encodedData2, forKey: "accountType")
        
        self.defaults.synchronize()
        let notificationName = NSNotification.Name("loggedInUser")
        NotificationCenter.default.post(name: notificationName, object: nil)        
    }
    
    func isLoggedIn() -> Bool {
        return !(self.username.isEmpty)
    }
    
    func clearDefaults() {
        self.username = ""
        self.accountType = ""
        let encodedData = self.username
        let encodedData2 = self.accountType
        self.defaults.set(encodedData, forKey: "username")
        self.defaults.set(encodedData2, forKey: "accountType")
        self.defaults.synchronize()
        let notificationName = NSNotification.Name("clearDefaults")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func getUsername() -> String {
        return self.username
    }
    
}
