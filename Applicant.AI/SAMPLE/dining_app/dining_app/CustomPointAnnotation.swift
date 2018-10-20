//
//  CustomPointAnnotion.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/29/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
    
}
