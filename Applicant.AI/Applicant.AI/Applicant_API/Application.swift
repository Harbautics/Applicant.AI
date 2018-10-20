//
//  Application.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/20/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

public class Application: NSObject {
    // Properties
    public let organization_name: String
    public let position_name: String
    // questions array
    
    
    // Description -- for debugging
    override public var description: String {
        return "\(self.organization_name) - \(self.position_name)"
    }
    
    // Initializations
    init(organization_name_in: String, position_name_in: String) {
        self.organization_name = organization_name_in
        self.position_name = position_name_in
        super.init()
    }
    
    // Convenience Init (JSON) -- requires SwiftyJSON
//    convenience init?(json: JSON) {
//
//    }
    
}
