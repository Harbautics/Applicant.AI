//
//  DiningLocation.swift
//  DiningMenus
//
//  Created by Maxim Aleksa on 3/13/17.
//  Copyright © 2017 Maxim Aleksa. All rights reserved.
//

import Foundation
import CoreLocation


// MARK: - Dining Location class

/// Represents a dining location on campus (e.g., Java Blue café in East Quad
/// or East Quad Dining Hall)
public class DiningLocation: NSObject, NSCoding {
    
    /// Type of dining location, such as café, dining hall or market
    public enum DiningLocationType: Int {
        case Cafe
        case DiningHall
        case Market
    }
    
    /// Represents the address of a Dining Location
    public struct Address: CustomStringConvertible {
        /// Street component of address
        public let street: String
        /// City component of address
        public let city: String
        /// State component of address
        public let state: String
        /// ZIP code
        public let zip: String
        
        /// Full address string
        public var fullAddress: String {
            return "\(street) \(city) \(state) \(zip)"
        }
        
        /// Textual representation of address that shows the full address
        public var description: String {
            return fullAddress
        }
    }
    
    /// Name of dining location
    public let name: String
    /// ID of dining location, used to uniquely identify it
    /// (e.g., in an API request or when saving favorites)
    public let id: String
    /// Address of dining location
    public let address: Address
    /// Geographical coordinate of dining location
    public let coordinate: CLLocationCoordinate2D
    /// Type of dining location (Cafe, DiningHall or Market)
    public let type: DiningLocationType
    /// Regular open hours of this dining location, represented as an array of strings,
    /// where each string is a new line of text
    public let hours: [String]
    /// Regular open hours of this dining location, represented as an array of dictionaries,
    /// where each element in the array is a dictionary corresponding to each day of the week
    /// (element at index 0 is dictionary corresponding to Sunday)
    ///
    /// Each dictionary has...
    /// keys that are strings representing the description of the event (e.g., "Brunch")
    /// and values that represent open times for that event (e.g., "10:30 AM – 2 PM")
    public let detailedHours: [[String: String]]
    /// Contact phone number for this dining location
    public let contactPhone: String?
    /// Contact email address for this dining location
    public let contactEmail: String?
    /// Capacity of dining location
    public var capacity: Int?
    /// Current occupancy of dining location
    public var currentOccupancy: Int?
    
    init(name: String, id: String, address: Address, coordinate: CLLocationCoordinate2D, type: DiningLocationType, hours: [String], detailedHours: [[String: String]], contactPhone: String? = nil, contactEmail: String? = nil, capacity: Int? = nil, currentOccupancy: Int? = nil) {
        self.name = name
        self.id = id
        self.address = address
        self.coordinate = coordinate
        self.type = type
        self.hours = hours
        self.detailedHours = detailedHours
        self.contactPhone = contactPhone
        self.contactEmail = contactEmail
        self.capacity = capacity
        self.currentOccupancy = currentOccupancy
        
        super.init()
    }
    
    convenience init?(json: JSON) {
        if let name = json["name"].string,
            let id = json["id"].string,
            let state = json["address"]["state"].string,
            let city = json["address"]["city"].string,
            let street = json["address"]["street"].string,
            let zip = json["address"]["zip"].string,
            let latitude = json["coordinate"]["latitude"].double,
            let longitude = json["coordinate"]["longitude"].double,
            let typeString = json["type"].string {
            
            var type: DiningLocation.DiningLocationType
            if typeString == "cafe" {
                type = .Cafe
            } else if typeString == "market" {
                type = .Market
            } else {
                type = .DiningHall
            }
            
            let address = DiningLocation.Address(street: street, city: city, state: state, zip: zip)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            var hours = [String]()
            if let jsonHours = json["hours"].array {
                for jsonHour in jsonHours {
                    if let hourString = jsonHour.string {
                        hours.append(hourString)
                    }
                }
            }
            
            var detailedHours = [[String: String]]()
            if let jsonDetailedHours = json["detailedHours"].array {
                for jsonDay in jsonDetailedHours {
                    var hoursForDay = [String: String]()
                    for (event, json):(String, JSON) in jsonDay {
                        if let hours = json[event].string {
                            hoursForDay[event] = hours
                        }
                    }
                    detailedHours.append(hoursForDay)
                }
            }
            
            let contactPhone = json["contact"]["phone"].string
            let contactEmail = json["contact"]["email"].string
            
            let capacity = json["capacity"].int
            
            self.init(name: name, id: id, address: address, coordinate: coordinate, type: type, hours: hours, detailedHours: detailedHours, contactPhone: contactPhone, contactEmail: contactEmail, capacity: capacity)
        } else {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    private struct PropertyKey {
        static let name = "name"
        static let id = "id"
        static let addressStreet = "addressStreet"
        static let addressCity = "addressCity"
        static let addressState = "addressState"
        static let addressZip = "addressZip"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let type = "type"
        static let hours = "hours"
        static let detailedHours = "detailedHours"
        static let contactPhone = "contactPhone"
        static let contactEmail = "contactEmail"
        static let capacity = "capacity"
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(address.street, forKey: PropertyKey.addressStreet)
        aCoder.encode(address.city, forKey: PropertyKey.addressCity)
        aCoder.encode(address.state, forKey: PropertyKey.addressState)
        aCoder.encode(address.zip, forKey: PropertyKey.addressZip)
        aCoder.encode(coordinate.latitude, forKey: PropertyKey.latitude)
        aCoder.encode(coordinate.longitude, forKey: PropertyKey.longitude)
        aCoder.encode(type.rawValue, forKey: PropertyKey.type)
        aCoder.encode(hours, forKey: PropertyKey.hours)
        aCoder.encode(contactPhone, forKey: PropertyKey.contactPhone)
        aCoder.encode(contactEmail, forKey: PropertyKey.contactEmail)
        aCoder.encode(capacity, forKey: PropertyKey.capacity)
    }
    
    required public convenience init?(coder aDecoder: NSCoder) {
        let typeRaw = aDecoder.decodeInteger(forKey: PropertyKey.type)
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String,
            let id = aDecoder.decodeObject(forKey: PropertyKey.id) as? String,
            let addressStreet = aDecoder.decodeObject(forKey: PropertyKey.addressStreet) as? String,
            let addressCity = aDecoder.decodeObject(forKey: PropertyKey.addressCity) as? String,
            let addressState = aDecoder.decodeObject(forKey: PropertyKey.addressState) as? String,
            let addressZip = aDecoder.decodeObject(forKey: PropertyKey.addressZip) as? String,
            let type = DiningLocationType.init(rawValue: typeRaw),
            let hours = aDecoder.decodeObject(forKey: PropertyKey.hours) as? [String],
            let detailedHours = aDecoder.decodeObject(forKey: PropertyKey.detailedHours) as? [[String: String]] else {
                return nil
        }
        
        let address = Address(street: addressStreet, city: addressCity, state: addressState, zip: addressZip)
        let latitude = aDecoder.decodeDouble(forKey: PropertyKey.latitude)
        let longitude = aDecoder.decodeDouble(forKey: PropertyKey.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let contactPhone = aDecoder.decodeObject(forKey: PropertyKey.contactPhone) as? String
        let contactEmail = aDecoder.decodeObject(forKey: PropertyKey.contactEmail) as? String
        
        let capacity: Int?
        if aDecoder.containsValue(forKey: PropertyKey.capacity) {
            capacity = aDecoder.decodeInteger(forKey: PropertyKey.capacity)
        } else {
            capacity = nil
        }
        
        self.init(name: name, id: id, address: address, coordinate: coordinate, type: type, hours: hours, detailedHours: detailedHours, contactPhone: contactPhone, contactEmail: contactEmail, capacity: capacity)
    }
    
    /// Textual representation of the dining location object that shows its name
    override public var description: String {
        return self.name
    }
}
