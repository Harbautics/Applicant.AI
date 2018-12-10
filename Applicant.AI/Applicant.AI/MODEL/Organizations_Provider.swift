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
    var postIDS = [Int]() // posts user applied to, straight from API
    var orgIDS = [Int]() // orgs user applied to, requires matching
    
    // Global Variable used for access
    static let shared = Organizations_Provider()
    
    // Initialization -- runs when app opens (only if called from somewhere else in the app!)
    // private init allows only 1 instance
    private init() {
        // make the api call, callback function
        ApplicantAPIManager.getOrganizationsGet { (orgs) in
            // fill the organizations array
            self.organizations = orgs
            
            print("calling match from orgs")
            self.matchOrganizations()
            
            // post notification saying it was loaded successfully
            let notificationName = NSNotification.Name("OrganizationsLoaded")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        ApplicantAPIManager.getAllSubmissions { (apps) in
            self.apps = apps
            self.postIDS.removeAll()
            for item in apps {
                let newID = Int(item.appid) ?? -2
                self.postIDS.append(newID)
            }
            
            print("calling match from subs")
            self.matchOrganizations()

            // post notification saying it was loaded successfully
            let notificationName = NSNotification.Name("SubmissionsLoaded")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    func refreshOrganizations() {
        print("calling refresh")
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
            self.postIDS.removeAll()
            for item in apps {
                let newID = Int(item.appid) ?? -2
                self.postIDS.append(newID)
            }
            
            print("calling match from subs")
            self.matchOrganizations()
            
            // post notification saying it was loaded successfully
            let notificationName = NSNotification.Name("SubmissionsLoaded")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    func refreshSubmissions() {
        print("calling refresh submissions")
        ApplicantAPIManager.getAllSubmissions { (apps) in
            self.apps = apps
            self.postIDS.removeAll()
            for item in apps {
                let newID = Int(item.appid) ?? -2
                self.postIDS.append(newID)
            }
            let notificationName = NSNotification.Name("SubmissionsLoaded")
            NotificationCenter.default.post(name: notificationName, object: nil)
            self.matchOrganizations()
        }
    }
    
    func matchOrganizations() {
        print("matching...")
        if self.organizations.count > 0 {
            // clear before matching
            self.orgIDS.removeAll()
            
            // go through all orgs
            for org in self.organizations {
                // get all the post ids
                var nextPostIDs = [Int]()
                if let posts = org.postings {
                    for post in posts {
                        nextPostIDs.append(post.id)
                    }
                }
                
                // go through all posting ids for that org
                for nextPost in nextPostIDs {
                    // if a match, add the org to the applied orgs array
                    if self.postIDS.contains(nextPost) {
                        let orgID = org.id
                        self.orgIDS.append(orgID)
                        org.userApplied = true
                        break
                    }
                }
                
            }
            let notificationName = NSNotification.Name("MatchedOrgsDone")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        //print(self.postIDS)
        //print(self.apps)
    }
    
    func getOrgNameAndType(ID: Int) -> (String, String) {
        for i in 0..<self.organizations.count {
            let nextID = self.organizations[i].id
            if ID == nextID {
                return (self.organizations[i].name, self.organizations[i].type)
            }
        }
        return ("Error", "Error")
    }
    
    func didUserApplyToOrg(orgID: Int) -> Bool {
        return self.orgIDS.contains(orgID)
    }
    
    func didUserApplyToPosting(postID: Int) -> Bool {
        return self.postIDS.contains(postID)
    }
    
    // user applied to an app
    func addApp(ID: Int) {
        if (!self.postIDS.contains(ID)) {
            self.postIDS.append(ID)
        }
        self.matchOrganizations()
    }
    
    // user applied to an org
    func addOrg(ID: Int) {
        if (!self.orgIDS.contains(ID)) {
            self.orgIDS.append(ID)
        }
        self.matchOrganizations()
    }
    
    // Function for logging out user, must clear their data
    func clearAll() {
        self.apps.removeAll()
        self.orgIDS.removeAll()
        self.postIDS.removeAll()
        self.organizations.removeAll()
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
