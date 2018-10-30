//
//  Application.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/20/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

// Application:
// This class represents an application.
// An app has a list of Questions
public class Application: NSObject {
    
    //Properties
    public let appid: String
    public let orgname: String
    public let name: String
    public let pos_description: String
    public let status: String
    public let questions: [Question]
    
    //Initialization
    init(appid:String, orgname:String, name:String, pos_description:String, status:String, questions: [Question]) {
        self.appid = appid
        self.orgname = orgname
        self.name = name
        self.pos_description = pos_description
        self.status = status
        self.questions = questions
        
        super.init()
    }
    // Convenience Init (JSON) -- requires SwiftyJSON
//    convenience init(json: JSON) {
//        if let appid = json["appid"].string {
//            
//        }
//    }
    
}
