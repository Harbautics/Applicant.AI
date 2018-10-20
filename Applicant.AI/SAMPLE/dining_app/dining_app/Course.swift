//
//  Course.swift
//  DiningMenus
//
//  Created by Maxim Aleksa on 3/13/17.
//  Copyright © 2017 Maxim Aleksa. All rights reserved.
//

import Foundation


// MARK: - Course class

/// Represents a category of menu items or a food station (e.g., 24 Carrots)
public class Course: CustomStringConvertible {
    
    /// Name of the course (e.g., 24 Carrots)
    public let name: String
    /// Array of menu items for this course
    public let menuItems: [MenuItem]
    
    init(name: String, menuItems: [MenuItem]) {
        self.name = name
        self.menuItems = menuItems
    }
    
    /// Textual representation of the course object that shows its name
    public var description: String {
        return self.name
    }
}
