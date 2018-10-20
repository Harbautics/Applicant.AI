//
//  CustomClosestLocationTableViewCell.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/10/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit
import MapKit

class CustomClosestLocationTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var closest_dining_distance: UILabel!
    @IBOutlet weak var closest_dining_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
