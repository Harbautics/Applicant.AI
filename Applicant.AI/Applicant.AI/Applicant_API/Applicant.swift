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
    public let id: String
    public let name: String
    
    // Constructors
    init(id_in: String, name_in: String) {
        self.id = id_in
        self.name = name_in
        
        super.init()
    }
    
    convenience init?(json: JSON) {
        // If we can pull the name and id from JSON
        if let name_JSON = json["name"].string,
            let id_JSON = json["id"].string {
            self.init(id_in: id_JSON, name_in: name_JSON)
        }
        else {
            return nil
        }
    }
    
    // Debugging Description
    public override var description: String {
        return "\(name), \(id)"
    }
}
