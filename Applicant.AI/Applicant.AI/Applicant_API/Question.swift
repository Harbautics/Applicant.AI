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
        if let question_JSON = json["question"].string,
            let type_JSON = json["type"].string,
            let answerJSON = json["answers"].array {
            
            // pulls out the list of potential answers, uses default value if no answers given
            let answerList = answerJSON.map { $0.string ?? "no answer select" }
            
            self.init(description_in: "no description provided", question_in: question_JSON, applicant_answer_in: "no applicant answer provided", type_in: type_JSON, answer_list_in: answerList)
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
