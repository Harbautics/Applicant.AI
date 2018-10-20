//
//  FavoritesManager.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/24/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import Foundation

class FavoritesManager {
    
    // Properties
    
    var favoriteMenuItemsStr = [String]()
    var favoriteLocationsStr = [String]()
    
    let defaults = UserDefaults.standard
    
    static let shared = FavoritesManager()
    
    // initializer
    private init() {
        self.favoriteLocationsStr = self.defaults.object(forKey: "favoriteLocations") as? [String] ?? [String]()
        
        self.favoriteMenuItemsStr = self.defaults.object(forKey: "favoriteItems") as? [String] ?? [String]()
        
        
        if self.favoriteLocationsStr.isEmpty {
            print("No Favorite Locations")
        }
        
        if self.favoriteMenuItemsStr.isEmpty {
            print("No Favorite Locations")
        }
        
        print("Finished Favorites Init")
    }
    
    
    // Member Functions
    
    // returns favorite menu items
    func getFavoriteMenuItems() -> [String] {
        return self.favoriteMenuItemsStr
    }
    
    // returns favorite locations
    func getFavoriteLocations() -> [String] {
        return self.favoriteLocationsStr
    }

    // adds a menuitem to favorites
    func addFavMenuItem(item: String) -> Void {
        if !self.favoriteMenuItemsStr.contains(item) {
            self.favoriteMenuItemsStr.append(item)
            self.saveFavItems()
        }
    }

    
    func addFavLocation(location: String) -> Void {
        if !self.favoriteLocationsStr.contains(location) {
            self.favoriteLocationsStr.append(location)
            self.saveFavLocationsStr()
        }
    }
 
    // removes a menu item from favorites
    // return true if successfully removed, false if not
    func removeMenuItem(item: String) {
        if let idx = self.favoriteMenuItemsStr.index(of: item) {
            self.favoriteMenuItemsStr.remove(at: idx)
            self.saveFavItems()
            print("Removed item from Favorites")
        }
        else {
            print("Could not remove item, no idx")
        }
    }

    
    func removeLocation(location: String) {
        if let idx = self.favoriteLocationsStr.index(of: location) {
            self.favoriteLocationsStr.remove(at: idx)
            self.saveFavLocationsStr()
            print("Removed Location from Favorites")
        }
        else {
            print("Could not remove location, no idx")
        }
    }
    
    // removes all favorite locations
    // returns true for success, false if array is already empty
    func removeAllFavoriteLocations() -> Bool {
        if self.favoriteLocationsStr.isEmpty {
            return false
        }
        else {
            self.favoriteLocationsStr.removeAll()
            self.saveFavLocationsStr()
            return true
        }
    }
    
    // removes all favorites menu items
    // returns true for success, false if array is already empty
    func removeAllFavItems() -> Bool {
        if self.favoriteMenuItemsStr.isEmpty {
            return false
        }
        else {
            self.favoriteMenuItemsStr.removeAll()
            self.saveFavItems()
            return true
        }
    }
    
    // removes all favorite menu items and locations
    func removeAll() {
        self.favoriteMenuItemsStr.removeAll()
        self.favoriteLocationsStr.removeAll()
        self.saveFavItems()
        self.saveFavLocationsStr()
    }
    
    // returns true if menu item is a favorite
    func isFavorite(item: String) -> Bool {
        return self.favoriteMenuItemsStr.contains(item)
    }
    
    // returns true if a location is a favorite by str
    func isFavorite(location: String) -> Bool {
        return self.favoriteLocationsStr.contains(location)
    }
    
    
    // stores the array of fav items to user defaults
    func saveFavItems() {
        let encodedData = self.favoriteMenuItemsStr
        self.defaults.set(encodedData, forKey: "favoriteItems")
        self.defaults.synchronize()
        UserDefaults.standard.synchronize()
        print("Saved Favorite Items")
        let notificationName = NSNotification.Name("SavedFavItem")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    // stores the array of fav locations to user defaults
    func saveFavLocationsStr() {
        let encodedData = self.favoriteLocationsStr
        self.defaults.set(encodedData, forKey: "favoriteLocations")
        self.defaults.synchronize()
        UserDefaults.standard.synchronize()
        print("Saved Favorite Locations")
        let notificationName = NSNotification.Name("SavedFavLocation")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    
}
