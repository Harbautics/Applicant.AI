//
//  RecruiterAPIManager.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/13/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

public class RecruiterAPIManager {
    //URLs for APIs
    private struct APIURLs {
        static let baseURL = "http://sdocsverification-env.dfcuq7wid3.us-east-2.elasticbeanstalk.com"
        static let getOrganizations = URL(string: "\(baseURL)/getOrganizationInfoFromEmail")!
        static let getPostings = URL(string: "TODO")!
        static let getApplicants = URL(string: "TODO")!
        static let getApplication = URL(string: "TODO")!
        static let setAppStatus = URL(string: "TODO")!
        static let createOrganization = URL(string: "http://sdocsverification-env.dfcuq7wid3.us-east-2.elasticbeanstalk.com/CreateOrg")!
    }
    
    // A generic fetch that gets JSON and calls the completion handler
    private class func fetch(url: URL, completionHandler: @escaping ((JSON?) -> Void)){
        // use a separate thread
        DispatchQueue.global(qos: .default).async {
            // this is the fetch!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                // if we get an error
                if error != nil {
                    print(error!)
                    completionHandler(nil)
                } else {
                    // got data, call completion handler
                    if data != nil {
                        let json = JSON(data: data!)
                        completionHandler(json)
                    } else {
                        completionHandler(nil)
                    }
                }
            }
            task.resume()
        }
    }
    
    private class func postData(url: URL, data: [String: String], completionHandler: @escaping ((JSON?) -> Void )) {
        print("making request")
        
        // use a separate thread
        DispatchQueue.global(qos: .default).async {
            // build request
            let config = URLSessionConfiguration.default
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            //request.httpBody = data.rawData() // TODO: configure json data
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                
                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    let json = JSON(data: data)
                    completionHandler(json)
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    // Creates an organization in the database
    public class func createOrganization(data: [String: String], completionHandler: @escaping ((JSON) -> Void)) {
        print("creating organization...")
        let url = APIURLs.createOrganization
        var response = JSON()
        postData(url: url, data: data) { (json) in
            response = json ?? ["response": "no response"]
            completionHandler(response)
        }
    }
    
    public class func getAllOrganizationsForRecruiter(completionHandler: @escaping ((Organization) -> Void)) {
        let url = APIURLs.getOrganizations
        
        let jsonObject = [
            "email": Login_Provider.shared.getUsername()
        ]
        var response = JSON()
        
        postData(url: url, data: jsonObject) { (json) in
            response = json ?? ["response": "no response"]
            
            if let orgs = response["organizations"].array {
                if orgs.count == 0 {
                    completionHandler(Organization())
                }
                else {
                    let newID = String(orgs[0]["id"].int ?? -1)
                    completionHandler(Organization(id: newID, json: orgs[0]) ?? Organization())
                }
            }
            else {
                completionHandler(Organization())
            }
        }
    }
}
