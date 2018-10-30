//
//  Applications_Provider.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/30/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

// A global object that holds and manages all the applications for a given user
class Applications_Provider {
    
    // Properties
    var applications = [Application]()
    
    // Global Variable used for access
    static let shared = Applications_Provider()
    
    // Initialization -- runs when app opens
    private init() {
        // make the api call -- for a single user!
            // Callback:
                // fill the applications array
                // post notification saying it was loaded successfully
                let notificationName = NSNotification.Name("ApplicationsLoaded")
                NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    
    // Member Functions
    
    // Printing for debugging
    func printAllOrgs() {
        for app in self.applications {
            print(app.name)
        }
    }
}
