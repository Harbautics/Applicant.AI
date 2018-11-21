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
    
    // Initialization -- runs when app opens (only if called from somewhere else in the app!)
    // private init allows only 1 instance
    private init() {
        // make the api call, callback function
        ApplicantAPIManager.getOrganizationsGet { (orgs) in
            // fill the organizations array
            self.organizations = orgs
            
            // post notification saying it was loaded successfully
            let notificationName = NSNotification.Name("OrganizationsLoaded")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    func refreshOrganizations() {
        print("calling refresh")
        ApplicantAPIManager.getOrganizationsGet { (orgs) in
            // fill the organizations array
            self.organizations = orgs
            
            // post notification saying it was loaded successfully
            let notificationName = NSNotification.Name("OrganizationsLoaded")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    // Member Functions
    func getAllOrganizations() -> [Organization] {
        return self.organizations
    }
    
    // Printing for debugging
    func printAllOrgs() {
        for org in self.organizations {
            print(org.name)
        }
    }
}
