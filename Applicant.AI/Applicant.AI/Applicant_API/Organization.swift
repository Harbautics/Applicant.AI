//
//  Organization.swift
//  Applicant.AI
//
//  Created by Alexis Opsasnick on 10/28/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

public class Organization: NSObject {
    
    public struct Member: CustomStringConvertible {
        public var description: String
        
        public let id: String
        public let name: String

    }
    
    public struct Posting: CustomStringConvertible {
        public var description: String
        
        public struct Question: CustomStringConvertible {
            public var description: String
            
            public let question: String
            public let type: String
            public let answers: [String]
        }
        
        public struct Applicant: CustomStringConvertible {
            public var description: String
            
            public let id: String
            public let name: String
            public let answers: [String]
            
        }
        
        public let id: String
        public let name: String
        public let jobDescription: String
        public let questions: [Question]
        public let applicants: [Applicant]
        

    }
    
    //Properties
    public let name: String
    public let id: String
    public let members: [Member]
    public let postings: [Posting]
    
    
    // Initializations
    init(name:String, id:String, members:[Member], postings:[Posting] ){
        self.id = id
        self.name = name
        self.members = members
        self.postings = postings
        
        super.init()
    }
}
