//
//  CustomMapCellTableViewCell.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/29/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol CustomMapCellDelegate {
    func callSegueFromCell(myData dataobject: String)
}

class CustomMapCellTableViewCell: UITableViewCell, CLLocationManagerDelegate, MKMapViewDelegate {

    // Properties
    var currentLocation = CLLocation()
    var locationmManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1500
    
    var diningLocations = [DiningLocation]()
    
    
    var pointAnnotation: CustomPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    var delegate: CustomMapCellDelegate!
    
    
    // Outlets
    @IBOutlet weak var map: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // initializing the location manager
        locationmManager.delegate = self
        locationmManager.desiredAccuracy = kCLLocationAccuracyBest
        locationmManager.requestWhenInUseAuthorization()
        locationmManager.startUpdatingLocation()
        
        // getting the dining locations
        self.diningLocations = MenusProvider.shared.locations
        
        // configuring the map
        map.delegate = self
        //map.mapType = MKMapType.standard
        map.showsUserLocation = true
        
        // setting up the map
        let initialLocation = CLLocation(latitude: 42.277241, longitude: -83.738158)
        self.currentLocation = initialLocation
        self.centerMapOnLocation(centerLocation: initialLocation)
        
        self.addAllPins()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Map Stuff!
    // centers the map for a given location!
    func centerMapOnLocation(centerLocation: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate,
                                                                  self.regionRadius * 1.5, self.regionRadius * 1.5)
        self.map.setRegion(coordinateRegion, animated: true)
    }
    
    // updates the user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
    }
    
    // if location manager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //MARK: - Custom Annotation
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
        pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if self.delegate != nil {
                self.delegate.callSegueFromCell(myData: ((view.annotation?.title)!)!)
            }
        }
    }
    
    func addAllPins() {
        
        for location in self.diningLocations {
            // if location is a favorite, make the pin red!
            if FavoritesManager.shared.isFavorite(location: location.name) {
                pointAnnotation = CustomPointAnnotation(pinColor: GlobalVariables.red)
                pointAnnotation.coordinate = location.coordinate
                pointAnnotation.title = location.name
                pointAnnotation.subtitle = "\(location.type)"
                map.addAnnotation(pointAnnotation)
            }
            // if the location is a market or cafe, make the pin orange!
            else if location.type == .Cafe || location.type == .Market {
                pointAnnotation = CustomPointAnnotation(pinColor: GlobalVariables.orange)
                pointAnnotation.coordinate = location.coordinate
                pointAnnotation.title = location.name
                pointAnnotation.subtitle = "\(location.type)"
                map.addAnnotation(pointAnnotation)
            }
            // if the location is a dining hall, make the pin blue
            else {
                pointAnnotation = CustomPointAnnotation(pinColor: GlobalVariables.blue)
                pointAnnotation.coordinate = location.coordinate
                pointAnnotation.title = location.name
                pointAnnotation.subtitle = "\(location.type)"
                map.addAnnotation(pointAnnotation)
            }
        }
    }
}
