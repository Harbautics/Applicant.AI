//
//  Application.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/20/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

public class Application: NSObject {
    
    public struct question: CustomStringConvertible {
        public var description: String
        
        public var question: String
        public var answer: String
    }
    
    //Properties
    public let appid: String
    public let orgname: String
    public let name: String
    public let pos_description: String
    public let status: String
    public let questions: [question]
    
    //Initialization
    init(appid:String, orgname:String, name:String, pos_description:String, status:String, questions: [question]){
        self.appid = appid
        self.orgname = orgname
        self.name = name
        self.pos_description = pos_description
        self.status = status
        self.questions = questions
        
        super.init()
    }
//    // Properties
//    public let organization_name: String
//    public let position_name: String
//    // questions array
//
//
//    // Description -- for debugging
//    override public var description: String {
//        return "\(self.organization_name) - \(self.position_name)"
//    }
//
//    // Initializations
//    init(organization_name_in: String, position_name_in: String) {
//        self.organization_name = organization_name_in
//        self.position_name = position_name_in
//        super.init()
//    }
    
    // Convenience Init (JSON) -- requires SwiftyJSON
//    convenience init?(json: JSON) {
//
//    }
    
}
