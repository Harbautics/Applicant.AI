//
//  TraitsTableViewCell.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/21/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit

class TraitsTableViewCell: UITableViewCell {

    
    // Outlets
    @IBOutlet weak var traitsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
