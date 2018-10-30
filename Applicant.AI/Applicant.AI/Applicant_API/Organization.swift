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
    
    // Debeugging Description
    public override var description: String {
        return "\(id): \(name)"
    }
}


