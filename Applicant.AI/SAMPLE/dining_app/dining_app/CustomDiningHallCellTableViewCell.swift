//
//  CustomDiningHallCellTableViewCell.swift
//  dining_app
//
//  Created by Jordan Wolff on 2/28/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit

class CustomDiningHallCellTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var OpenNow: UILabel!
    @IBOutlet weak var DiningName: UILabel!
    @IBOutlet weak var DiningType: UILabel!
    
    let green = UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0)
    let red = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
    let yellow = UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0)
    let grey = UIColor(red:0.58, green:0.58, blue:0.60, alpha:1.0)
    
    var accessoryButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        accessoryButton = subviews.flatMap { $0 as? UIButton }.first
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessoryButton?.frame.origin.y = 24
        accessoryButton?.frame.origin.x = 345
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
