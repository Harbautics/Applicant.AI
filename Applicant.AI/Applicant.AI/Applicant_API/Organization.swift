//
//  Organization.swift
//  Applicant.AI
//
//  Created by Alexis Opsasnick on 10/28/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

// Represents the member of an organization
// Not used outside the organization
public class Member: NSObject {
    
    // Properties
    public let id: String
    public let name: String
    
    // Constructors
    init(id_in: String, name_in: String) {
        self.id = id_in
        self.name = name_in
        
        super.init()
    }
}

// Represents an organization
// organizations contains members and postings
public class Organization: NSObject {
    
    //Properties
    public let name: String
    public let id: String
    public let members: [Member]?
    public let postings: [Posting]?
    
    
    // Constructors
    init(name:String, id:String, members:[Member]?, postings: [Posting]? ){
        self.id = id
        self.name = name
        self.members = members
        self.postings = postings
        
        super.init()
    }
    
    init(name: String, id: String) {
        self.id = id
        self.name = name
        self.members = [Member]()
        self.postings = [Posting]()
    }
    
    convenience init?(json: JSON) {
        // if we can pull information from JSON Response
        if let name_JSON = json["name"].string,
            let id_JSON = json["id"].string,
            let members_JSON = json["members"].array,
            let postings_JSON = json["postings"].array {
            
            // Go through the array of members, create and append member to the members array
            var members_array = [Member]()
            for member in members_JSON {
                members_array.append(Member(id_in: member["id"].string!, name_in: member["name"].string!))
            }
            // Go through the array of postings, create and append posting to the posting array
            var postings_array = [Posting]()
            for posting in postings_JSON {
                
                // go through the questions and applicants, create and append
                var questions_array = [Question]()
                var applicants_array = [Applicant]()
                for question in posting["questions"].array! {
                    questions_array.append(Question(description_in: question["description"].string!, question_in: question["question"].string!, applicant_answer_in: question["answer"].string!))
                }
                for applicant in posting["applicants"].array! {
                    applicants_array.append(Applicant(id_in: applicant["id"].string!, name_in: applicant["name"].string!))
                }
                
                postings_array.append(Posting(name_in: posting["name"].string!, id_in: posting["id"].string!, status_in: posting["status"].string!, job_desc_in: posting["job-description"].string!, questions_in: questions_array, applicants_in: applicants_array))
            }
            
            self.init(name: name_JSON, id: id_JSON, members: members_array, postings: postings_array)
        }
        else {
            return nil
        }
    }
    
    // Debeugging Description
    public override var description: String {
        return "\(id): \(name)"
    }
}


