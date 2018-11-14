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
        static let getOrganizations = URL(string: "http://sdocsverification-env.dfcuq7wid3.us-east-2.elasticbeanstalk.com/getOrganizationInfo")!
        static let submitApplication = URL(string: "http://testing.com")!
        static let getApplications = URL(string: "TODO")!
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
                        completionHandler(json)
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
            //request.httpBody = data.rawData() // TODO: configure json data
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: url as URL, completionHandler: {(data, response, error) in
                if error != nil {
                    debugPrint(error!)
                }
                else {
                    if data != nil {
                        let json = JSON(data:data!)
                        completionHandler(json)
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
    
    // TODO: finish this
    public class func submitApplication(data: [[String: Any]], completionHandler: @escaping () -> Void) {
        print("submitting...")
        let url = APIURLs.submitApplication
        let dataJSON = JSON(arrayLiteral: data)
        
        postData(url: url, data: dataJSON) { (json) in
            print(json)
        }
        // get back on the main queue and continue
        DispatchQueue.main.async {
            completionHandler()
        }
    }
}
