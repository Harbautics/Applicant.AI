//
//  ApplicantAPIManager.swift
//  Applicant.AI
//
//  Created by Alexis Opsasnick on 10/28/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation
import CoreLocation

public class ApplicantAPIManager {
    
    //URLs for APIs
    private struct APIURLs {
        static let getOrganizations = URL(string: "https://applicant.ai/api/get-all-organizations")!
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
    
    
    // Get Organizations from the API
    public class func getOrganizations(completionHandler: @escaping (([Organization]) -> Void )) {
        
        var organizations = [Organization]()
        
        // get dining hall data
        let url = APIURLs.getOrganizations
        fetch(url: url) { (json) in
            if let organizationsJSON = json?.array {
                organizations = organizationsJSON.map { Organization(json: $0)! }
            }
            
            // Make sure we're back on the main thread
            DispatchQueue.main.async {
                completionHandler(organizations)
            }
        }
    }
}
