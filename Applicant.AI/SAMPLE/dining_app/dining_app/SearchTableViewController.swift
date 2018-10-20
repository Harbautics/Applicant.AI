//
//  SearchTableViewController.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/10/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension SearchTableViewController: UISearchResultsUpdating, CustomMapCellDelegate {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class SearchTableViewController: UITableViewController, CLLocationManagerDelegate {

    // Properties
    var diningLocations = [DiningLocation]()
    var randomDiningLocation: DiningLocation!
    var closestDiningLocation: DiningLocation!
    var closestDiningDistance = Double.infinity
    var currentLocation = CLLocation()
    var locationManager = CLLocationManager()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredLocations = [DiningLocation]()
    
    var meals = MenusProvider.shared.locationMenus
    
    // dictionary with list of dining halls now
    var filteredMenuItems = [String:[String]]()
    
    var arrayForDict = [MenuItem]()
    
    var mealChosen: String = "Breakfast"
    
    // this is the name of the location we want to pass from the map to a different view controller
    var nameToPass = ""
    
    // Outlets
    @IBOutlet weak var mealSelection: UISegmentedControl!
    
    @IBAction func mealChoice(_ sender: UISegmentedControl) {
        // update the meals
        self.meals = MenusProvider.shared.locationMenus
        
        // change selection
        if mealSelection.selectedSegmentIndex == 0 {
            self.mealChosen = "Breakfast"
        }
        else if mealSelection.selectedSegmentIndex == 1 {
            self.mealChosen = "Lunch"
        }
        else if mealSelection.selectedSegmentIndex == 2 {
            self.mealChosen = "Dinner"
        }
        else {
            print("Error in Meal Selection")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // notifications
        let notificationName = NSNotification.Name("NotificationIdf")
        NotificationCenter.default.addObserver(self, selector: #selector(SearchTableViewController.reloadTableView), name: notificationName, object: nil)
        
        
        self.diningLocations = MenusProvider.shared.locations
        self.meals = MenusProvider.shared.locationMenus
        
        
        self.title = "Discover"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if diningLocations.count != 0 {
            self.findNearestDiningLocation()
            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
    }
    
    func reloadTableView() {
        self.meals = MenusProvider.shared.locationMenus
        self.findNearestDiningLocation()
        self.tableView.reloadData()
        print("Reload Search")
    }

    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        var results = [String:[String]]()
        // keep track of menu items we've already seen
        var encountered = Set<String>()
        
        var resultsArray = [MenuItem]()
        
        // update meals if there arent many
        if (self.meals.count < 21) {
            self.meals = MenusProvider.shared.locationMenus
            print("Updated meals from MenusProvider")
        }
        
        for (key, _) in self.meals {
            if MenusProvider.shared.locations[MenusProvider.shared.locationDictionary[key]!].type != .Cafe
            &&  MenusProvider.shared.locations[MenusProvider.shared.locationDictionary[key]!].type != .Market {
                if self.meals[key] != nil {
                    for item in self.meals[key]! {
                        if item.type.rawValue == self.mealChosen {
                            if item.courses != nil {
                                
                                // take a second to update meals
                                self.meals = MenusProvider.shared.locationMenus
                                
                                for course in item.courses! {
                                    if course.menuItems.count != 0 {
                                        for menuitem in course.menuItems {
                                            if menuitem.name.localizedCaseInsensitiveContains(searchText) {
                                                // don't include the no service menu item
                                                if menuitem.name != "No Service at this Time" {
                                                    var name = key
                                                    // remove dining hall from name
                                                    if name.contains(" Dining Hall") {
                                                        name = name.replacingOccurrences(of: " Dining Hall", with: "")
                                                    }
                                                    
                                                    if results[menuitem.name]?.count == nil {
                                                        let array = [name]
                                                        results[menuitem.name] = array
                                                    }
                                                    else if !results[menuitem.name]!.contains(name) {
                                                        results[menuitem.name]!.append(name)
                                                    }
                                                    
                                                    // if the item is not already in results
                                                    // add it to the array for indexing!
                                                    if !encountered.contains(menuitem.name) {
                                                        // append result
                                                        resultsArray.append(menuitem)
                                                        // add to set
                                                        encountered.insert(menuitem.name)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.filteredMenuItems = results
        self.arrayForDict = resultsArray

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // menu items or map
        if section == 0 || section == 2 {
            return ""
        }
        // closest lcoation
        else {
            return "Closest Location:"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredMenuItems.count
            }
            else {
                return 0
            }
        }
        // closest location and map
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // menu item
        if indexPath.section == 0 {
            return 66.0
        }
        // closest location
        else if indexPath.section == 1 {
            return 44.0
        }
        // map
        else {
            return 487.0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // search cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchIdentifier", for: indexPath) as! SearchItemTableViewCell
            
            if searchController.isActive  && searchController.searchBar.text != "" {
                
                // main text
                let menuItemName = arrayForDict[indexPath.row].name
                cell.dining_name.text = menuItemName
                
                // subtitle text
                cell.subTitle.text = ""
                var subTitleText = ""
                
                if let array = self.filteredMenuItems[menuItemName] {
                    if array.count != 0 {
                        for item in array {
                            subTitleText += item
                            if item != array[array.endIndex - 1] {
                                subTitleText += ", "
                            }
                        }
                    }
                }
                
                
                cell.subTitle.text = subTitleText
                
            }
            else {
                cell.dining_name.text = ""
                cell.subTitle.text = ""
                cell.isUserInteractionEnabled = false
                cell.accessoryType = .none
            }
            
            return cell
            
        }
        // closest dining location cell
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClosestLocationIdentifier", for: indexPath) as! CustomClosestLocationTableViewCell
            
            let edgeInset = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 0.0)
            cell.separatorInset = edgeInset
            
            self.findNearestDiningLocation()
                        
            // customize cell
            // if distance is too far, show the first dining location in the list
            if (self.closestDiningDistance > 10000) {
                cell.closest_dining_name.text = "Searching..."
                cell.closest_dining_distance.text = ""
            }
            // otherwise show the dining location
            else {
                let convertedDistance = self.closestDiningDistance * 3
                let distance_str = String(format: "%.2f", convertedDistance)
                cell.closest_dining_distance.text = distance_str + " ft away"
                cell.closest_dining_name.text = "\(self.closestDiningLocation.name)"
            }
            
            return cell
        }
        // map
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMapCell", for: indexPath) as! CustomMapCellTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selected closest dining
        if indexPath.section == 1 {
            // open maps with location
            let cell = self.tableView.cellForRow(at: indexPath)
            if cell?.textLabel?.text != "" {
                self.openMapForPlace()
                
            }
        }
    }
    
    func openMapForPlace() {
        let coordinate = self.closestDiningLocation.coordinate
        let latitude: CLLocationDegrees = coordinate.latitude
        let longitude: CLLocationDegrees = coordinate.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
            ] as [String: Any]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.closestDiningLocation.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0]
    }
    
    
    func findNearestDiningLocation() {
        var minDistance = Double.infinity
        for location in self.diningLocations {
            let cur_location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            if  cur_location.distance(from: self.currentLocation) < minDistance {
                minDistance = cur_location.distance(from: self.currentLocation)
                self.closestDiningLocation = location
            }
        }
        
        self.closestDiningDistance = minDistance
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
    
    func callSegueFromCell(myData dataobject: String) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        
        let name = dataobject
        self.nameToPass = name
        
        self.performSegue(withIdentifier: "pinToLocation", sender: dataobject)
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SearchToMenuItem" {
            if let MenuItemTVC = segue.destination as? MenuItemTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if searchController.isActive {
                        MenuItemTVC.selectedMenuItem = arrayForDict[indexPath.row]
                        MenuItemTVC.title = arrayForDict[indexPath.row].name
                    }
                }
            }
        }
        
        if segue.identifier == "pinToLocation" {
            if let SpecificTVC = segue.destination as? Specific_Dining_ViewController {
                for location in self.diningLocations {
                    if location.name == self.nameToPass {
                        SpecificTVC.selectedDiningLocation = location
                        SpecificTVC.title = location.name
                        SpecificTVC.selectedDiningName = location.name
                        break
                    }
                }
            }
        }
        
    }
    

}
