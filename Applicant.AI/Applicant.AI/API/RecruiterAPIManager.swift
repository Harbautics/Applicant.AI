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
        static let createOrganization = URL(string: "\(baseURL)/CreateOrg")!
        static let createPosting = URL(string: "\(baseURL)/CreatePosting")!
        static let createUser = URL(string: "\(baseURL)/CreateUser")!
        static let updateApplicantStatus = URL(string: "\(baseURL)/updateApplicant")!
        static let getAllApplicantsFromPosting = URL(string: "\(baseURL)/getApplicantsFromPosting")!
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
                        //completionHandler(json)
                        DispatchQueue.main.async {
                            completionHandler(json)
                        }
                    } else {
                        //completionHandler(nil)
                        DispatchQueue.main.async {
                            completionHandler(nil)
                        }
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
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
//                print(data)
//                print(response)
//                print(error)
                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    let json = JSON(data: data)
                    //completionHandler(json)
                    DispatchQueue.main.async {
                        completionHandler(json)
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    private class func postData(url: URL, data: JSON, completionHandler: @escaping ((JSON?) -> Void )) {
        print("making request")
        
        // use a separate thread
        DispatchQueue.global(qos: .default).async {
            // build request
            let config = URLSessionConfiguration.default
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
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
                    //completionHandler(json)
                    DispatchQueue.main.async {
                        completionHandler(json)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    private class func postData(url: URL, data: [String: Any], completionHandler: @escaping ((JSON?) -> Void)) {
        print("making request")
        
        // use a separate thread
        DispatchQueue.global(qos: .default).async {
            // build request
            let config = URLSessionConfiguration.default
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
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
                    //completionHandler(json)
                    DispatchQueue.main.async {
                        completionHandler(json)
                    }
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
            //completionHandler(response)
            DispatchQueue.main.async {
                completionHandler(response)
            }
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
                    //completionHandler(Organization())
                    DispatchQueue.main.async {
                        completionHandler(Organization())
                    }
                }
                else {
                    let newID = String(orgs[0]["id"].int ?? -1)
                    // get back on the main queue and call the completionHandler with the data
                    DispatchQueue.main.async {
                        completionHandler(Organization(id: newID, json: orgs[0]) ?? Organization())
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completionHandler(Organization())
                }
            }
        }
    }
    
    public class func createPosting(data: [String: Any], completionHandler: @escaping ((JSON) -> Void)) {
        let url = APIURLs.createPosting
        //let dataJSON = JSON(arrayLiteral: data)
        
        var response = JSON()
        
        postData(url: url, data: data) { (json) in
            response = json ?? ["response": "no response"]
            //completionHandler(response)
            DispatchQueue.main.async {
                completionHandler(response)
            }
        
        }
        
//        postData(url: url, data: dataJSON) { (json) in
//            response = json ?? ["response": "no response"]
//            completionHandler(response)
//        }
    }
    
    public class func createUser(data: [String: String], completionHandler: @escaping ((JSON) -> Void)) {
        let url = APIURLs.createUser
        
        var response = JSON()
        
        postData(url: url, data: data) { (json) in
            response = json ?? ["response": "no response"]
            //completionHandler(response)
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }
    }
    
    public class func updateApplicantStatus(status: String, applicantEmail: String, postId: Int, completionHandler: @escaping ((JSON) -> Void)) {
        let url = APIURLs.updateApplicantStatus
        
        var response = JSON()
        
        let jsonObject: [String: Any] = [
            "status": status,
            "post_id": postId,
            "email": applicantEmail
        ]
        postData(url: url, data: jsonObject) { (json) in
            response = json ?? ["response": "no response"]
            //completionHandler(response)
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }
        
    }
    
    public class func getAllApplicantsForPosting(orgName: String, posName: String, completionHandler: @escaping (([Applicant]) -> Void))  {
        // applicants
            // questions
                // answer question
            // perc_match: double
            // status
            // userinfo
                // email
                // id
                // name
        let url = APIURLs.getAllApplicantsFromPosting
        let jsonObject: [String: String] = [
            "org_name": orgName,
            "pos_name": posName
        ]
        
        var applicants = [Applicant]()
        
        postData(url: url, data: jsonObject) { (json) in
            if let applicantsJSON = json?["applicants"].array {
                applicants = applicantsJSON.map { Applicant(json: $0) ?? Applicant() }
                
                DispatchQueue.main.async {
                    completionHandler(applicants)
                }
            }
            else {
                DispatchQueue.main.async {
                    completionHandler([Applicant()])
                }
            }
        }
    }

}
