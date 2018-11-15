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
    public var name: String
    public var id: Int
    public var status: String
    public var job_description: String
    public var questions: [Question]?
    public var applicants: [Applicant]?
    
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
        self.applicants = [Applicant]()
        
        super.init()
    }
    override init() {
        self.name = "Default Name"
        self.id = -1
        self.status = "open"
        self.job_description = ""
        self.questions = [Question]()
        self.applicants = [Applicant]()
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
