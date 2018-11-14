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
        static let getOrganizations = URL(string: "TODO")!
        static let getPostings = URL(string: "TODO")!
        static let getApplicants = URL(string: "TODO")!
        static let getApplication = URL(string: "TODO")!
        static let setAppStatus = URL(string: "TODO")!
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
}
