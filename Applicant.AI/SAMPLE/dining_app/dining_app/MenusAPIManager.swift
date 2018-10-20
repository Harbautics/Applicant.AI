//
//  MenusAPIManager.swift
//  DiningMenus
//
//  Created by Maxim Aleksa on 2/25/17.
//  Copyright © 2017 Maxim Aleksa. All rights reserved.
//

import Foundation
import CoreLocation


// MARK: - MenusAPIManager


/// Communicates with dining hall menus API
public class MenusAPIManager {
    
    /// URLs for APIs
    private struct APIURLs {
        static let diningLocations = URL(string: "https://eecs183.org/api/menus/v1/diningLocations.json")!
        static let occupancy = URL(string: "https://mobile.its.umich.edu/michigan/services/dining/shallowDiningHallGroups?_type=json")!
        static func menusURL(for diningLocation: DiningLocation, on date: Date) -> URL {
            let baseURLString = "http://api.studentlife.umich.edu/menu/xml2print.php"
            
            let escapedID = diningLocation.id.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            let stringDate = formatter.string(from: date)
            
            let urlString = "\(baseURLString)?controller=print&view=json&location=\(escapedID)&date=\(stringDate)"
            return URL(string: urlString)!
        }
    }
    
    /// Simplifies access to APIs
    ///
    /// Gets data at the specified `url` and converts it to `JSON`,
    /// calling `completionHandler` when finished.
    private class func fetch(url: URL, completionHandler: @escaping ((JSON?) -> Void)) {
        // get off the main queue to avoid blocking rendering of UI
        DispatchQueue.global(qos: .default).async {
            // let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
            // let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    completionHandler(nil)
                } else {
                    if data != nil {
                        let json = JSON(data: data!)
                        completionHandler(json)
                    } else {
                        completionHandler(nil)
                    }
                }
            }
            task.resume()
        }
    }
    
    /// Gets dining locations from the API.
    ///
    /// This is an asynchronous function that calls `completionHandler`
    /// when data is fetched from the API.
    public class func getDiningLocations(completionHandler: @escaping (([DiningLocation]) -> Void)) {
        
        // dictionary that maps dining location names to occupancies
        var occupancies = [String: Int]()
        
        var diningLocations = [DiningLocation]()
        
        var didLoadDiningLocations = false
        var didLoadOccupancies = false
        
        func matchOccupancies() {
            if didLoadDiningLocations && didLoadOccupancies {
                // match occupancies
                for diningLocation in diningLocations {
                    if let currentOccupancy = occupancies[diningLocation.name] {
                        diningLocation.currentOccupancy = currentOccupancy
                    }
                }
                // ensure we are on the main queue
                DispatchQueue.main.async {
                    completionHandler(diningLocations)
                }
            }
        }
        
        // get dining hall data
        let url = APIURLs.diningLocations
        fetch(url: url) { (json) in
            if let locationsJSON = json?.array {
                let locations = locationsJSON.map { DiningLocation(json: $0) }
                diningLocations = locations.removeNils()
            }
            didLoadDiningLocations = true
            matchOccupancies()
        }
        
        // get occupancy data
        let occupancyURL = APIURLs.occupancy
        fetch(url: occupancyURL) { (json) in
            if let jsonArray = json?["diningHallGroup"].array {
                for group in jsonArray {
                    for diningLocationJSON in group["diningHall"].arrayValue {
                        if let name = diningLocationJSON["name"].string, let currentOccupancy = diningLocationJSON["hallCapacity"]["currentOccupancy"].int {
                            
                            occupancies[name] = currentOccupancy
                        }
                    }
                }
            }
            didLoadOccupancies = true
            matchOccupancies()
        }
    }
    
    
    /// Gets meals for specified dining location and date (that defaults to
    /// today's date) from the API.
    ///
    /// This is an asynchronous function that calls `completionHandler`
    /// when data is fetched from the API.
    public class func getMeals(for diningLocation: DiningLocation, on date: Date = Date(), completionHandler: @escaping (([Meal]) -> Void)) {
        
        let url = APIURLs.menusURL(for: diningLocation, on: date)
        fetch(url: url) { (json) in
            if let mealsJSON = json?["menu"]["meal"].array {
                var meals = mealsJSON.map({ (json) -> Meal? in
                    if let name = json["name"].string {
                        var type: Meal.MealType!
                        
                        if name == "BREAKFAST" {
                            type = .Breakfast
                        } else if name == "LUNCH TRANSITION" {
                            type = .LunchTransition
                        } else if name == "LUNCH" {
                            type = .Lunch
                        } else if name == "DINNER TRANSITION" {
                            type = .DinnerTransition
                        } else if name == "DINNER" {
                            type = .Dinner
                        } else if name == "PARSTOCKS" || name == "SMART TEMPS" {
                            type = .Other
                        }
                        
                        if type != nil {
                            
                            var coursesJSONArray: [JSON]?
                            if let jsonArray = json["course"].array {
                                coursesJSONArray = jsonArray
                            } else if json["course"].dictionary != nil {
                                coursesJSONArray = [json["course"]]
                            }
                            let courses = coursesJSONArray?.map({ (json) -> Course? in
                                if let name = json["name"].string {
                                    var menuItems = [MenuItem?]()
                                    func jsonToMenuItem(json: JSON) -> MenuItem? {
                                        return MenuItem(json: json)
                                    }
                                    if let _ = json["menuitem"].dictionary {
                                        menuItems = [jsonToMenuItem(json: json["menuitem"])]
                                    } else if let menuItemArray = json["menuitem"].array {
                                        menuItems = menuItemArray.map(jsonToMenuItem)
                                    }
                                    return Course(name: name.trimmingCharacters(in: CharacterSet.whitespaces), menuItems: menuItems.removeNils())
                                }
                                return nil
                            })
                            let message = json["message"]["content"].string
                            return Meal(type: type, courses: courses?.removeNils(), message: message)
                        }
                    }
                    return nil
                })
                
                // combine "other" meals and remove nils
                var newMeals = [Meal]()
                var otherMeal: Meal?
                for meal in meals {
                    if meal != nil {
                        if meal?.type == .Other {
                            if otherMeal == nil {
                                otherMeal = meal
                            } else {
                                // add courses
                                if meal?.courses != nil {
                                    let otherCourses = otherMeal?.courses ?? []
                                    let newCourses = otherCourses + meal!.courses!
                                    otherMeal = Meal(type: .Other, courses: newCourses)
                                }
                            }
                        } else {
                            newMeals.append(meal!)
                        }
                    }
                }
                if otherMeal != nil {
                    newMeals.append(otherMeal!)
                }
                
                // ensure we are on the main queue
                DispatchQueue.main.async {
                    completionHandler(newMeals)
                }
            } else {
                
                // ensure we are on the main queue
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
    
    
    /// Gets current occupancy of the specified dining locaiton, if available.
    /// `currentOccupancy` is `nil` if occupancy data is not available.
    ///
    /// This is an asynchronous function that calls `completionHandler`
    /// when data is fetched from the API.
    public class func getCurrentOccupancy(for diningLocation: DiningLocation, completionHandler: @escaping ((_ currentOccupancy: Int?) -> Void)) {
        // get occupancy data
        let occupancyURL = APIURLs.occupancy
        fetch(url: occupancyURL) { (json) in
            var occupancy: Int? = nil
            if let jsonArray = json?["diningHallGroup"].array {
                for group in jsonArray {
                    for diningLocationJSON in group["diningHall"].arrayValue {
                        if let name = diningLocationJSON["name"].string, let currentOccupancy = diningLocationJSON["hallCapacity"]["currentOccupancy"].int {
                            
                            if name == diningLocation.name {
                                occupancy = currentOccupancy
                                break
                            }
                        }
                    }
                }
            }
            // ensure we are on the main queue
            DispatchQueue.main.async {
                completionHandler(occupancy)
            }
        }
    }
    
    
    /// Gets actual hours (accounting for holiday and special event hours)
    /// for the specified dining locaiton is open on the specified date.
    ///
    /// Hours are provided as an array of tuples, where each tuple is composed of
    /// `eventTitle`, a string such as `"Brunch"`, `"Dinner"` or `"Open"`,
    /// and `hours`, a string representing hours for that event (e.g., `"7:00 AM – 2:00 PM"`).
    ///
    /// This is an asynchronous function that calls `completionHandler`
    /// when data is fetched from the API.
    public class func getHours(for diningLocation: DiningLocation, on date: Date, completionHandler: @escaping (([(eventTitle: String, hours: String)]) -> Void)) {
        
        MenusAPIManager.getHours(for: diningLocation, on: date) { (events: [(eventTitle: String, hours: (start: Date, end: Date))]) in
            var result = [(String, String)]()
            for (eventTitle, (start: startDate, end: endDate)) in events {
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                let hours = "\(formatter.string(from: startDate)) – \(formatter.string(from: endDate))"
                result.append((eventTitle, hours))
            }
            completionHandler(result)
        }
    }
    
    
    /// Gets actual hours (accounting for holiday and special event hours)
    /// for the specified dining locaiton is open on the specified date.
    ///
    /// Hours are provided as an array of tuples, where each tuple is composed of
    /// `eventTitle`, a string such as `"Brunch"`, `"Dinner"` or `"Open"`,
    /// and another tuple, composed of `start`, a date representing the start of the event,
    /// and `end`, a date representing the end of the event.
    ///
    /// This is an asynchronous function that calls `completionHandler`
    /// when data is fetched from the API.
    public class func getHours(for diningLocation: DiningLocation, on date: Date, completionHandler: @escaping (([(eventTitle: String, hours: (start: Date, end: Date))]) -> Void)) {
        let url = APIURLs.menusURL(for: diningLocation, on: date)
        fetch(url: url) { (json) in
            let jsonArray: [JSON]
            if json?["hours"]["calendar_event"].array != nil {
                jsonArray = json!["hours"]["calendar_event"].array!
            } else if json?["hours"]["calendar_event"].dictionary != nil {
                jsonArray = [json!["hours"]["calendar_event"]]
            } else {
                jsonArray = []
            }
            
            var events = [(eventTitle: String, (start: Date, end: Date))]()
            for eventJSON in jsonArray {
                if let eventTitle = eventJSON["event_title"].string, let startString = eventJSON["event_time_start"].string, let endString = eventJSON["event_time_end"].string {
                    if let startDate = startString.dateFromISO8601, let endDate = endString.dateFromISO8601 {
                        events.append((eventTitle, (startDate, endDate)))
                    }
                }
            }
            // ensure we are on the main queue
            DispatchQueue.main.async {
                completionHandler(events)
            }
        }
    }
    
    
    /// Checks if the specified dining locaiton is open on the specified date.
    ///
    /// This is an asynchronous function that calls `completionHandler`
    /// when data is fetched from the API.
    public class func isOpen(_ diningLocation: DiningLocation, on date: Date, completionHandler: @escaping ((Bool) -> Void)) {
        MenusAPIManager.getHours(for: diningLocation, on: date, completionHandler: { (events: [(eventTitle: String, hours: (start: Date, end: Date))]) in
            
            var isOpen = false
            for (_, hours) in events {
                if (hours.start...hours.end).contains(date) {
                    isOpen = true
                }
            }
            completionHandler(isOpen)
        })
    }
}


// MARK: - Extensions

// filtering out nil values
// http://stackoverflow.com/questions/28190631/creating-an-extension-to-filter-nils-from-an-array-in-swift
protocol OptionalType {
    associatedtype Wrapped
    func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

extension Sequence where Iterator.Element: OptionalType {
    func removeNils() -> [Iterator.Element.Wrapped] {
        var result: [Iterator.Element.Wrapped] = []
        for element in self {
            if let element = element.map({ $0 }) {
                result.append(element)
            }
        }
        return result
    }
}

// dates
// based on http://stackoverflow.com/questions/28016578/swift-how-to-create-a-date-time-stamp-and-format-as-iso-8601-rfc-3339-utc-tim
extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}
