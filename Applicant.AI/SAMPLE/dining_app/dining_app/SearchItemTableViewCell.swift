//
//  SearchItemTableViewCell.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/10/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit

class SearchItemTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var dining_name: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
