//
//  Applicant.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/30/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

// Represents a person who has applied to an application
public class Applicant: NSObject {
    
    // Properties
    public var id: Int
    public var name: String
    public var percentageMatch: Double
    public var email: String
    public var status: String
    public var questions: [Question]
    
    // Constructors
    init(id_in: Int, name_in: String, perc_in: Double, email_in: String, status_in: String, questions_in: [Question]) {
        self.id = id_in
        self.name = name_in
        self.percentageMatch = perc_in
        self.email = email_in
        self.status = status_in
        self.questions = questions_in
        super.init()
    }
    override init() {
        self.id = -1
        self.name = "no name"
        self.percentageMatch = -1.0
        self.email = "no email"
        self.status = "no status"
        self.questions = [Question(description_in: "", question_in: "", applicant_answer_in: "", type_in: "", answer_list_in: [""])]
        super.init()
    }
    
//    init(id_in: Int, name_in: String) {
//        self.id = id_in
//        self.name = name_in
//        self.percentageMatch = Double((Float(Float(arc4random()) / Float(UINT32_MAX)) * 100.0)) // TODO: no more random percentage
//
//        super.init()
//    }
    
//    override init() {
//        self.id = -1
//        self.name = "default name"
//        self.percentageMatch = Double((Float(Float(arc4random()) / Float(UINT32_MAX)) * 100.0)) // TODO: no more random percentage
//        super.init()
//    }
    
    convenience init?(json: JSON) {
        if let questionJSON = json["questions"].array,
            let percJSON = json["perc_match"].double,
            let statusJSON = json["status"].string,
            let userInfoJSON = json["userInfo"].dictionary {
            
            let email = userInfoJSON["email"]?.string
            let id = userInfoJSON["id"]?.int
            let name = userInfoJSON["name"]?.string
            
            let questions = questionJSON.map { Question(json: $0)}
            
            self.init(id_in: id ?? -1, name_in: name ?? "no name", perc_in: percJSON, email_in: email ?? "no email", status_in: statusJSON, questions_in: questions as! [Question])
        }
        else {
            return nil
        }
//
//
//
//        // If we can pull the name and id from JSON
//        if let name_JSON = json["name"].string,
//            let id_JSON = json["id"].int {
//            self.init(id_in: id_JSON, name_in: name_JSON)
//        }
//        else {
//            return nil
//        }
    }
    
    // Debugging Description
    public override var description: String {
        return "\(name), \(id)"
    }
}
