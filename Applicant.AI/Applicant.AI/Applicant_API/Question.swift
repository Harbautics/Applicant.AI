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
    public var type: String
    public var answers_list: [String]
    
    // Initializatiom
    init(description_in: String, question_in: String, applicant_answer_in: String, type_in: String, answer_list_in: [String]) {
        self.sub_description = description_in
        self.question = question_in
        self.applicant_answer = applicant_answer_in
        self.type = type_in
        self.answers_list = answer_list_in
        
        super.init()
    }
    
    // Init from JSON object
    convenience init?(json: JSON) {
        // question, type, answers[]
        // if we can pull the description, question, and applicants answer from JSON
        if let question = json.string {
            self.init(description_in: "no description provided", question_in: question, applicant_answer_in: "no applicant answer provided", type_in: "text", answer_list_in: [""])
        }
        else {
            return nil
        }
    }
    
    // Debugging
    override public var description: String  {
        return "\(self.question), \(self.applicant_answer)"
    }
}
