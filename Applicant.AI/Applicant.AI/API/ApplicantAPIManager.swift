//
//  ApplicantAPIManager.swift
//  Applicant.AI
//
//  Created by Alexis Opsasnick on 10/28/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

public class ApplicantAPIManager {
    
    //URLs for APIs
    private struct APIURLs {
        static let baseURL = "http://sdocsverification-env.dfcuq7wid3.us-east-2.elasticbeanstalk.com"
        static let getOrganizations = URL(string: "\(baseURL)/getOrganizationInfo")!
        static let submitApplication = URL(string: "\(baseURL)/CreateSubmission")!
        static let getApplications = URL(string: "\(baseURL)/getAllSubmissions")!
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
                        DispatchQueue.main.async {
                            completionHandler(json)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completionHandler(nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // A generic post that posts JSON, waits for response and calls the completion handler
    private class func postData(url: URL, data: String, completionHandler: @escaping ((JSON?) -> Void)) {
        
        print("making request")
        
        // use a separate thread
        DispatchQueue.global(qos: .default).async {
            // build request
            let config = URLSessionConfiguration.default
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            let bodyData = data
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: url as URL, completionHandler: {(data, response, error) in
                if error != nil {
                    debugPrint(error!)
                }
                else {
                    if data != nil {
                        let json = JSON(data:data!)
                        DispatchQueue.main.async {
                            completionHandler(json)
                        }
                    }
                    else {
                        print("No data!")
                    }
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
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: url as URL, completionHandler: {(data, response, error) in
                if error != nil {
                    debugPrint(error!)
                }
                else {
                    if data != nil {
                        let json = JSON(data:data!)
                        DispatchQueue.main.async {
                            completionHandler(json)
                        }
                    }
                    else {
                        print("No data!")
                    }
                }
            })
            task.resume()
            
        }
        // get back on the main queue and call the completionHandler with the data
        DispatchQueue.main.async {
            completionHandler(data)
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
    
    
    public class func getOrganizationsGet(completionHandler: @escaping (([Organization]) -> Void )) {
        print("get all organizations get")
        var organizations = [Organization]()
        let url = APIURLs.getOrganizations
        fetch(url: url) { (json) in
            // if we can pull out of the JSON
            if let organizationsJSON = json?.dictionary!["organizations"] {
                for item in organizationsJSON {
                    let (ID, json_resp) = item
                    // use the convenience init
                    organizations.append(Organization(id: ID, json: json_resp)!)
                }
            }
            // get back on the main queue and call the completionHandler with the data
            DispatchQueue.main.async {
                completionHandler(organizations)
            }
        }
    }
    
    public class func submitApplication(data: [String: Any], completionHandler: @escaping (JSON) -> Void) {
        print("submitting...")
        let url = APIURLs.submitApplication        
        
        postData(url: url, data: data) { (json) in
            DispatchQueue.main.async {
                completionHandler(json ?? ["response": "no response"])
            }
        }
    }
    
    public class func getAllSubmissions(completionHandler: @escaping ([Application]) -> Void) {
        let url = APIURLs.getApplications
        
        let jsonObject: [String: String] = [
            "email": Login_Provider.shared.getUsername()
        ]
        
        var applications = [Application]()
        
        postData(url: url, data: jsonObject) { (json) in
            print(type(of: json))
            let applicationsJSON = json?["submissions"] ?? ["response":"no response"]
            
            applications = applicationsJSON.map { Application(json: $0.1)! }
            
            DispatchQueue.main.async {
                completionHandler(applications)
            }
        }
        
    }
}
