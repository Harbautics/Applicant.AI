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
    var apps = [Application]()
    var appID = [Int]()
    
    // Global Variable used for access
    static let shared = Organizations_Provider()
    
    // Initialization -- runs when app opens (only if called from somewhere else in the app!)
    // private init allows only 1 instance
    private init() {
        // make the api call, callback function
        ApplicantAPIManager.getOrganizationsGet { (orgs) in
            // fill the organizations array
            self.organizations = orgs
            
            self.matchOrganizations()
            
            // post notification saying it was loaded successfully
            let notificationName = NSNotification.Name("OrganizationsLoaded")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        ApplicantAPIManager.getAllSubmissions { (apps) in
            self.apps = apps
            for item in apps {
                let newID = Int(item.appid) ?? -2
                self.appID.append(newID)
            }
            // post notification saying it was loaded successfully
            let notificationName = NSNotification.Name("SubmissionsLoaded")
            NotificationCenter.default.post(name: notificationName, object: nil)
            self.matchOrganizations()
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
    
    func refreshSubmissions() {
        print("calling refresh submissions")
        ApplicantAPIManager.getAllSubmissions { (apps) in
            self.apps = apps
            let notificationName = NSNotification.Name("SubmissionsLoaded")
            NotificationCenter.default.post(name: notificationName, object: nil)
            self.matchOrganizations()
        }
    }
    
    func matchOrganizations() {
        if self.organizations.count > 0 {
            for i in 0..<self.organizations.count {
                let int_id = Int(self.organizations[i].id) ?? -1
                if self.appID.contains(int_id) {
                    self.organizations[i].userApplied = true
                }
            }
            let notificationName = NSNotification.Name("MatchedOrgsDone")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    func getOrgNameAndType(ID: Int) -> (String, String) {
        for i in 0..<self.organizations.count {
            let nextID = Int(self.organizations[i].id)
            if ID == nextID {
                return (self.organizations[i].name, self.organizations[i].type)
            }
        }
        return ("Error", "Error")
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
