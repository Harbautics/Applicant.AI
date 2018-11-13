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
    public var id: Int
    public var name: String
    
    // Constructors
    init(id_in: Int, name_in: String) {
        self.id = id_in
        self.name = name_in
        
        super.init()
    }
    convenience init?(json: JSON) {
        if let nameJSON = json["name"].string,
           let idJSON = json["id"].int {
           self.init(id_in: idJSON, name_in: nameJSON)
        }
        else {
            return nil
        }
    }
}

// Represents an organization
// organizations contains members and postings
public class Organization: NSObject {
    
    //Properties
    public var name: String
    public var id: String
    public var members: [Member]?
    public var postings: [Posting]?
    
    
    // Constructors
    // init with all data
    init(name:String, id:String, members:[Member]?, postings: [Posting]? ){
        self.id = id
        self.name = name
        self.members = members
        self.postings = postings
        
        super.init()
    }
    // init with just name and id
    init(name: String, id: String) {
        self.id = id
        self.name = name
        self.members = [Member]()
        self.postings = [Posting]()
        super.init()
    }
    // only to be used when creating a new organization, then will set the correct ID later on
    init(name_in: String) {
        self.name = name_in
        self.id = "-1"
        self.members = [Member]()
        self.postings = [Posting]()
        super.init()
    }
    // default constructor - init with no data
    override init() {
        self.id = "default"
        self.name = "default"
        self.members = [Member]()
        self.postings = [Posting]()
        super.init()
    }
    
    // init from JSON
    convenience init?(id: String, json: JSON) {
        if let name_JSON = json["name"].string,
            let membersJSON = json["members"].array,
            let postingsJSON = json["postings"].array {
            
            // $0 just means for each JSON entry - for each JSON entry, create a new Member/Posting
            let memberList = membersJSON.map { Member(json: $0) }
            let postingList = postingsJSON.map {Posting(json: $0) }
            
            self.init(name: name_JSON, id: id, members: memberList as? [Member], postings: postingList as? [Posting])
        }
        else {
            self.init()
        }
    }
    
    // Debeugging Description
    public override var description: String {
        return "\(id): \(name)"
    }
}


