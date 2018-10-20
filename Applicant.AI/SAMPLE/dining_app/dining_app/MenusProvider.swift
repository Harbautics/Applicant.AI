//
//  MenusProvider.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/8/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import Foundation

// loads and stores all dining halls and their menu items
// called on app lauch
// stores information in a dictionary
class MenusProvider {
    
    // Properties
    
    // dictionary of locations and menu items
    // format:  "Dining Location Name": [array of meals]
    var locationMenus = [String:[Meal]]()
    
    // an array that contains the actual locations
    var locations = [DiningLocation]()
    
    // maps a name to the location in the locations array
    var locationDictionary = [String: Int]()
    
    // global variable to use
    static let shared = MenusProvider()
    
    
    // load all the locations and menu items
    // do this on launch
    private init() {
        MenusAPIManager.getDiningLocations { (locationsToLoad) in
            self.locations = locationsToLoad

            for index in 0..<self.locations.count {
                self.locationDictionary[self.locations[index].name] = index
                
                // get the meals
                var meals = [Meal]()
                MenusAPIManager.getMeals(for: self.locations[index], completionHandler: { (mealsToLoad) in
                    meals = mealsToLoad
                    self.locationMenus[self.locations[index].name] = meals
                    print(self.locations[index].name + " meals loaded")
                    
                    // post a notification
                    let notificationName = NSNotification.Name("NotificationIdf")
                    NotificationCenter.default.post(name: notificationName, object: nil)
                })
            }
        }
    }

    
    // functions
    
    // prints all of the dining locations and their courses
    func printAll() {
        for (key, values) in locationMenus {
            for value in values {
                print(key + "\(value)")
            }
        }
    }
    
    // insert function to return all results for a menu item search
    
}
