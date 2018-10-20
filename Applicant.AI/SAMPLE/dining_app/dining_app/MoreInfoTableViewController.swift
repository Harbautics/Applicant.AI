//
//  MoreInfoTableViewController.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/10/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MoreInfoTableViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // Properties
    
    var pointAnnotation: CustomPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    var delegate: CustomMapCellDelegate!
    
    // the name of the menu item the user wants more info about
    var menuItem: String = ""
    // an array of all the locations that serve the meal
    var locationsServed = [String]()
    // closest serving dining halls
    var closestServed = String()
    // map Annotations
    var mapAnnotations = [MKPointAnnotation]()
    // map radius
    let regionRadius: CLLocationDistance = 1500
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    // Outlets
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure the map
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.showsUserLocation = true
        map.delegate = self
        let initialLocation = CLLocation(latitude: 42.277241, longitude: -83.738158)
        self.currentLocation = initialLocation
        centerMapOnLocation(centerLocation: initialLocation)
        
        
        self.findAllDiningHalls(meal: self.menuItem)
        self.displayAllDiningHalls()
        self.highLightClosestRow()
        self.tableView.reloadData()
    }
    
    func centerMapOnLocation(centerLocation: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        self.map.setRegion(coordinateRegion, animated: true)
    }
    
    // updates the user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
        self.highLightClosestRow()
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
        // #warning Incomplete implementation, return the number of rows
        return locationsServed.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Being Served At: "
    }
    
    // finds all dining halls serving a specified meal
    func findAllDiningHalls(meal: String) {
        var potentialLocations = MenusProvider.shared.locationMenus
        
        // keeps track of duplicates
        var encountered = Set<String>()
        
        for (key, _) in potentialLocations {
            if potentialLocations[key] != nil {
                for item in potentialLocations[key]! {
                    if item.courses != nil {
                        for course in item.courses! {
                            if course.menuItems.count != 0 {
                                for menuitem in course.menuItems {
                                    if menuitem.name == self.menuItem {
                                        if !encountered.contains(key) {
                                            locationsServed.append(key)
                                            encountered.insert(key)
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
    
    // places markers for all dining halls on a map
    func displayAllDiningHalls() {
        for item in self.locationsServed {
            
            let location = MenusProvider.shared.locations[MenusProvider.shared.locationDictionary[item]!]
            
            // if location is a favorite, make the pin red!
            if FavoritesManager.shared.isFavorite(location: item) {
                pointAnnotation = CustomPointAnnotation(pinColor: GlobalVariables.red)
                pointAnnotation.coordinate = location.coordinate
                pointAnnotation.title = location.name
                pointAnnotation.subtitle = "\(location.address.fullAddress)"
                map.addAnnotation(pointAnnotation)
            }
                // if the location is a market or cafe, make the pin orange!
            else if location.type == .Cafe || location.type == .Market {
                pointAnnotation = CustomPointAnnotation(pinColor: GlobalVariables.orange)
                pointAnnotation.coordinate = location.coordinate
                pointAnnotation.title = location.name
                pointAnnotation.subtitle = "\(location.address.fullAddress)"
                map.addAnnotation(pointAnnotation)
            }
                // if the location is a dining hall, make the pin blue
            else {
                pointAnnotation = CustomPointAnnotation(pinColor: GlobalVariables.blue)
                pointAnnotation.coordinate = location.coordinate
                pointAnnotation.title = location.name
                pointAnnotation.subtitle = "\(location.address.fullAddress)"
                map.addAnnotation(pointAnnotation)
            }

            mapAnnotations.append(pointAnnotation)
            
        }
    }
    
    func highLightClosestRow() {
        var minDistance = Double.infinity
        
        for location in locationsServed {
            let hall = MenusProvider.shared.locations[MenusProvider.shared.locationDictionary[location]!]
            let cur_location = CLLocation(latitude: hall.coordinate.latitude, longitude: hall.coordinate.longitude)
            if cur_location.distance(from: self.currentLocation) < minDistance {
                minDistance = cur_location.distance(from: self.currentLocation)
                self.closestServed = location
            }
        }
        
        self.tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationServed", for: indexPath)

        cell.textLabel?.text = locationsServed[indexPath.row]
        
        // highlight the closest served
        if locationsServed[indexPath.row] == self.closestServed {
            cell.backgroundColor = GlobalVariables.green
            cell.textLabel?.text = locationsServed[indexPath.row] + ": closest!"
            cell.textLabel?.textColor = UIColor.white
        }
        
        if locationsServed[indexPath.row] != self.closestServed {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.map.selectAnnotation(mapAnnotations[indexPath.row], animated: true)
    }
    
    // if location manager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            let customAnnotation = annotation as! CustomPointAnnotation
            pinView?.pinTintColor = customAnnotation.pinColor
        }
        else {
            pinView?.annotation = annotation
        }
        
        pinView?.canShowCallout = true
        let button = UIButton(type: .detailDisclosure)
        button.setImage(UIImage(named: "navigation2"), for: .normal)
        pinView?.rightCalloutAccessoryView = button
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // open map!
            let title = view.annotation?.title
            self.openMapForPlace(location: (title!)!)
            print("Selected Accessory")
        }
    }

    func openMapForPlace(location: String) {
        
        let locationToPass = MenusProvider.shared.locations[MenusProvider.shared.locationDictionary[location]!]
        
        let coordinate = locationToPass.coordinate
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
        mapItem.name = locationToPass.name
        mapItem.openInMaps(launchOptions: options)
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

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */
    

}
