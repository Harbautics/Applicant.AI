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
    
    // Properties
    public var appid: String
    public var orgname: String
    public var name: String
    public var pos_description: String
    public var status: String
    public var questions: [Question]
    
    // Constructors
    init(appid:String, orgname:String, name:String, pos_description:String, status:String, questions: [Question]) {
        self.appid = appid
        self.orgname = orgname
        self.name = name
        self.pos_description = pos_description
        self.status = status
        self.questions = questions
        
        super.init()
    }
    
    convenience init?(json: JSON) {
        // if we can get the application information from JSON response
        if let appid_JSON = json["appid"].string,
            let orgname_JSON = json["orgname"].string,
            let name_JSON = json["name"].string,
            let pos_desc_JSON = json["position-description"].string,
            let status_JSON = json["status"].string,
            let questions_array_JSON = json["questions"].array {
            
            // Go through the array of questions, create and append question to the questions array
            var questions_array = [Question]()
            questions_array = questions_array_JSON.map { Question(json: $0)! }
//            for question in questions_array_JSON {
//                questions_array.append(Question(description_in: question["description"].string!, question_in: question["question"].string!, applicant_answer_in: question["answer"].string!))
//            }
            self.init(appid: appid_JSON, orgname: orgname_JSON, name: name_JSON, pos_description: pos_desc_JSON, status: status_JSON, questions: questions_array)
        }
        else {
            return nil
        }
    }
    
}
