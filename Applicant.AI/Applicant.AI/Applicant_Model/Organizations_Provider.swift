//
//  Organizations_Provider.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/30/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

// A global object that holds and manages all the organizations
class Organizations_Provider {
    
    // Properties
    var organizations = [Organization]()
    
    // Global Variable used for access
    static let shared = Organizations_Provider()
    
    // Initialization -- runs when app opens
    private init() {
        // make the api call
            // Callback:
                // fill the organizations array
                // post notification saying it was loaded successfully
                let notificationName = NSNotification.Name("OrganizationsLoaded")
                NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    // Member Functions
    
    // Printing for debugging
    func printAllOrgs() {
        for org in self.organizations {
            print(org.name)
        }
    }
}
