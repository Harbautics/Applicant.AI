//
//  Meal.swift
//  DiningMenus
//
//  Created by Maxim Aleksa on 3/13/17.
//  Copyright © 2017 Maxim Aleksa. All rights reserved.
//

import Foundation


// MARK: - Meal class

/// Represents a meal of the day (breakfast, lunch, dinner)
public class Meal: CustomStringConvertible {
    
    /// Type of meal (breakfast, lunch transition, lunch, dinner transition,
    /// dinner or other)
    public enum MealType: String {
        case Breakfast
        case LunchTransition = "Lunch Transition"
        case Lunch
        case DinnerTransition = "Dinner Transition"
        case Dinner
        case Other
    }
    
    /// Type of meal (Breakfast, LunchTransition, Lunch, DinnerTransition,
    /// Dinner or Other)
    public let type: MealType
    /// Array of courses for this meal.
    /// `courses` is `nil` if this meal is not served.
    public let courses: [Course]?
    /// A notice message informing the user about this meal
    /// (e.g., that this meal is not being served today)
    public let message: String?
    
    init(type: MealType, courses: [Course]?, message: String? = nil) {
        self.type = type
        self.courses = courses
        self.message = message
    }
    
    /// Textual representation of the meal object that shows its type
    public var description: String {
        return self.type.rawValue
    }
}
