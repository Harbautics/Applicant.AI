//
//  CustomCourseTableViewCell.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/2/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit

class CustomCourseTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var Menu_Item_Price: UILabel!
    @IBOutlet weak var Menu_Item_Name: UILabel!
    
    //var accessoryButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        accessoryType = .disclosureIndicator
//        accessoryButton = subviews.flatMap { $0 as? UIButton }.first
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        accessoryButton?.frame.origin.y = 50
//        accessoryButton?.frame.origin.x = 345
    }

}
