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
    
    let defaults = UserDefaults.standard
    
    static let shared = Login_Provider()
    
    private init() {
        self.username = self.defaults.object(forKey: "username") as? String ?? "no user"
        
        // notification
        let notificationName = NSNotification.Name("userFound")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func logInUser(usernameIn: String) {
        self.username = usernameIn
        let encodedData = usernameIn
        self.defaults.set(encodedData, forKey: "username")
        self.defaults.synchronize()
        let notificationName = NSNotification.Name("loggedInUser")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func isLoggedIn() -> Bool {
        return !(self.username.isEmpty)
    }
    
    func clearDefaults() {
        self.username = ""
        let encodedData = self.username
        self.defaults.set(encodedData, forKey: "username")
        self.defaults.synchronize()
        let notificationName = NSNotification.Name("clearDefaults")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func getUsername() -> String {
        return self.username
    }
    
}
