//
//  DiningHalls_TableViewController.swift
//  dining_app
//
//  Created by Jordan Wolff on 2/28/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//



import UIKit
import MapKit

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 44 // adjust your size here
        return sizeThatFits
    }
}

class DiningHalls_TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    // Properties
    // locations by name
    var diningLocations = [DiningLocation]()
    // locations by distance => an array of tuples, location and its current distance from user
    var locationsByDistance = [DiningLocation]()
    var nameToDistance = [String: Double]()
    // location manager stuff
    var currentLocation = CLLocation()
    var locationManager = CLLocationManager()
    
    // how to tell the table which to render
    var sortedBy = "Name"
    
    var favorites = [String]()
    
    // Outlets
    @IBOutlet weak var filter: UIBarButtonItem!
    
    
    // Actions
    @IBAction func filterAction(_ sender: UIBarButtonItem) {
        self.toggleFilter()
    
        if self.filter.title == "Name" {
            self.sortDistance()
        }
        else {
            self.sortName()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get favorites
        self.favorites = FavoritesManager.shared.getFavoriteLocations()
        
        // set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // set up dining halls
        self.diningLocations = MenusProvider.shared.locations
        self.locationsByDistance = MenusProvider.shared.locations
        
        // set up notifications
        let notificationName = NSNotification.Name("NotificationIdf")
        NotificationCenter.default.addObserver(self, selector: #selector(DiningHalls_TableViewController.reloadTableView), name: notificationName, object: nil)
        
        let favNotification = NSNotification.Name("SavedFavLocation")
        NotificationCenter.default.addObserver(self, selector: #selector(DiningHalls_TableViewController.reloadTableView), name: favNotification, object: nil)
        
        // title and tableView
        self.title = "Dining Halls"
        self.tableView.reloadData()

        // updat the distance dictionary
        self.updateNameToDistance()
    }

    func reloadTableView() {
        // get locations again
        self.diningLocations = MenusProvider.shared.locations
        self.locationsByDistance = MenusProvider.shared.locations
        
        // get favorites again
        self.favorites = FavoritesManager.shared.getFavoriteLocations()
        
        self.tableView.reloadData()
        self.updateNameToDistance()
        
        // update sorted order
        self.locationsByDistance.sort { (DiningLocation1, DiningLocation2) -> Bool in
            if let distance1 = self.nameToDistance[DiningLocation1.name] {
                if let distance2 = self.nameToDistance[DiningLocation2.name] {
                    return distance1 < distance2
                }
                else {
                    return true
                }
            }
            else {
                return true
            }
        }
    }
    
    // updates the dictionary mapping a name to a distacne
    func updateNameToDistance(){
        for location in self.locationsByDistance {
            let cur_location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            nameToDistance[location.name] = cur_location.distance(from: self.currentLocation)
        }
    }
    
    func toggleFilter() {
        if self.filter.title == "Distance" {
            self.filter.title = "Name"
            self.sortedBy = "Distance"
        }
        else {
            self.filter.title = "Distance"
            self.sortedBy = "Name"
        }
    }
    
    func sortDistance() {
        self.sortedBy = "Distance"
        self.tableView.reloadData()
    }
    
    func sortName() {
        self.sortedBy = "Name"
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diningLocations.count
    }
    
    // always getting current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiningHallCell", for: indexPath) as! CustomDiningHallCellTableViewCell
        
        // sorted by name!
        if self.sortedBy == "Name" {
            let location: DiningLocation = diningLocations[indexPath.row]
            
            // get the day of the week
            // Sunday: 1, Monday: 2, Tuesday: 3, Wednesday: 4, Thursday: 5, Friday: 6, Saturday: 7
            var weekday = Date().dayNumberOfWeek()!
            // subtract 1 for accessing array!
            weekday -= 1

            // get the current hour and minute: MILITARY TIME
            let today = NSDate()
            let current_hour = NSCalendar.current.component(.hour, from: today as Date)
            
            // access the openHours array at the current day, with the currentDiningLocation
            let possibleHours = GlobalVariables.openHours[weekday]["\(location.name)"]
            
            // go through the valid hours for that day of the week
            // check if valid hour
            var validHour = false
            var closingSoon = false
            if let totalHours = possibleHours {
                for possibleHour in possibleHours! {
                    if possibleHour == current_hour {
                        validHour = true
                    }
                }
            }
            else {
                validHour = false
            }
            
            // if valid hour, check if closing soon
            if validHour {
                if (current_hour <= (possibleHours?[(possibleHours?.count)! - 1])!) {
                    if ((current_hour - (possibleHours?[(possibleHours?.count)! - 1])!) <= 1
                        && (current_hour - (possibleHours?[(possibleHours?.count)! - 1])!) > 0) {
                        closingSoon = true
                    }
                }
            }
            
            // set the open/closed/closing soon label and appropriate color
            if validHour && closingSoon {
                cell.OpenNow.text = "Closing Soon"
                cell.OpenNow.textColor = UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0)
            }
            else if validHour {
                cell.OpenNow.text = "Open Now"
                cell.OpenNow.textColor = UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0)
            }
            else {
                cell.OpenNow.text = "Closed"
                cell.OpenNow.textColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
            }
            
            
            // Set the dining name and type labels
            var name = location.name
            if name.contains("Dining Hall") {
                name = name.replacingOccurrences(of: "Dining Hall", with: " ")
            }
            
            

            
            cell.DiningName.text = name
            
            let type_label = "\(location.type)"
            var final_label = ""
            
            if type_label == "Cafe" {
                final_label = "Café"
            }
            else if type_label == "Market" {
                final_label = type_label
            }
            else {
                let index = type_label.index(type_label.startIndex, offsetBy: 6)
                final_label = type_label.substring(to: index)
                final_label += " "
                final_label += type_label.substring(from: index)
            }
            
            if self.favorites.contains(self.diningLocations[indexPath.row].name) {
                final_label += "  ♥️"
            }
            
            cell.DiningType.text = final_label
            cell.DiningType.textColor = UIColor(red:0.58, green:0.58, blue:0.60, alpha:1.0)
     
            return cell
        }
        // sorted by distance!
        else {
            let location = self.locationsByDistance[indexPath.row]
            
            
            // Set the dining name and type labels
            var name = location.name
            if name.contains("Dining Hall") {
                name = name.replacingOccurrences(of: "Dining Hall", with: " ")
            }
            
            cell.DiningName.text = name
            
            let type_label = "\(location.type)"
            var final_label = ""
            
            if type_label == "Cafe" {
                final_label = "Café"
            }
            else if type_label == "Market" {
                final_label = type_label
            }
            else {
                let index = type_label.index(type_label.startIndex, offsetBy: 6)
                final_label = type_label.substring(to: index)
                final_label += " "
                final_label += type_label.substring(from: index)
            }
            
            if self.favorites.contains(self.locationsByDistance[indexPath.row].name) {
                final_label += "  ♥️"
            }
            
            // configure the type label
            cell.DiningType.text = final_label
            cell.DiningType.textColor = UIColor(red:0.58, green:0.58, blue:0.60, alpha:1.0)
            
            
            // set open now labels to be distances instead
            if let distance = self.nameToDistance[location.name] {
                let convertedDistance = distance * 3
                let distance_str = String(format: "%.2f", convertedDistance)
                cell.OpenNow.text = distance_str + " ft away"
                if convertedDistance < 2000 {
                    cell.OpenNow.textColor = GlobalVariables.green
                }
                else {
                    cell.OpenNow.textColor = UIColor(red:0.58, green:0.58, blue:0.60, alpha:1.0)
                }
            }
            else {
                // couldn't find dining distance
                cell.OpenNow.text = " "
            }
            
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0;
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
        if segue.identifier == "Hall_To_Specific" {
            if let SpecificTVC = segue.destination as? Specific_Dining_ViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if (self.sortedBy == "Name") {
                        SpecificTVC.selectedDiningLocation = MenusProvider.shared.locations[indexPath.row]
                        SpecificTVC.title = MenusProvider.shared.locations[indexPath.row].name
                        SpecificTVC.selectedDiningName = MenusProvider.shared.locations[indexPath.row].name
                    }
                    else {
                        SpecificTVC.selectedDiningLocation = self.locationsByDistance[indexPath.row]
                        SpecificTVC.title = self.locationsByDistance[indexPath.row].name
                        SpecificTVC.selectedDiningName = self.locationsByDistance[indexPath.row].name
                    }
                }
            }
        }
    }
}
