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
    private struct APIURLS {
        
    }
    
    private class func fetch(url: URL, completionHandler: @escaping ((JSON?) -> Void)){
        DispatchQueue.global(qos: .default).async {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    completionHandler(nil)
                } else {
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
    
    
}
