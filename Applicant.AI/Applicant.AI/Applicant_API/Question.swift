//
//  Question.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/30/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

// A single question for an application
// may contain the applicants response
public class Question: NSObject {
    
    // Properties
    public var sub_description: String
    public var question: String
    public var applicant_answer: String?
    
    // Initializatiom
    init(description_in: String, question_in: String, applicant_answer_in: String) {
        self.sub_description = description_in
        self.question = question_in
        self.applicant_answer = applicant_answer_in
        super.init()
    }
    
    // Init from JSON object
    convenience init?(json: JSON) {
        // if we can pull the description, question, and applicants answer from JSON
        if let sub_description_JSON = json["description"].string,
            let question_JSON = json["question"].string,
            let answer_JSON = json["answer"].string {
            
            self.init(description_in: sub_description_JSON, question_in: question_JSON, applicant_answer_in: answer_JSON)
        }
        else {
            return nil
        }
    }
    
    // Debugging
    override public var description: String  {
        return "\(self.question), \(self.sub_description)"
    }
}
