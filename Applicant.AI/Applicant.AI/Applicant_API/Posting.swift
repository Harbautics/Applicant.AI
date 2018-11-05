//
//  Posting.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/30/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

// Posting represents a new position
// postings contain description, questions, and a list of who's applied
public class Posting: NSObject {
    
    // Properties
    public let name: String
    public let id: Int
    public let status: String
    public let job_description: String
    public let questions: [Question]?
    public let applicants: [Applicant]?
    
    // Constructors
    init(name_in: String, id_in: Int, status_in: String, job_desc_in: String, questions_in: [Question]?, applicants_in: [Applicant]?) {
        self.name = name_in
        self.id = id_in
        self.status = status_in
        self.job_description = job_desc_in
        self.questions = questions_in
        self.applicants = applicants_in
        
        super.init()
    }
    init(name_in: String, id_in: Int, status_in: String, job_desc_in: String, questions_in: [Question]) {
        self.name = name_in
        self.id = id_in
        self.status = status_in
        self.job_description = job_desc_in
        self.questions = questions_in
        self.applicants = [Applicant]() // TODO: convenience init for applicant
        
        super.init()
    }
    
    convenience init?(json: JSON) {
        if let nameJSON = json["name"].string,
            let idJSON = json["id"].int,
            let statusJSON = json["status"].string,
            let jobDescJSON = json["description"].string,
            let questionsJSON = json["questions"].array {
            
            let questionList = questionsJSON.map { Question(json: $0) }
            
            self.init(name_in: nameJSON, id_in: idJSON, status_in: statusJSON, job_desc_in: jobDescJSON, questions_in: questionList as! [Question])
        }
        else {
            return nil
        }
        
    }
}
