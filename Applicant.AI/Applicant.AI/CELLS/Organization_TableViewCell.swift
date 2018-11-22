//
//  Organization_TableViewCell.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/21/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Organization_TableViewCell: UITableViewCell {

    
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var organizationLocation: UILabel!
//    @IBOutlet weak var backgroundShadow: UIView!
//    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
//    func configure() {
//        self.backgroundShadow.backgroundColor = UIColor.white
//        self.contentView.backgroundColor = globals.colors.bgGrey
//        //self.backgroundShadow.layer.cornerRadius = 3.0
//        //self.backgroundShadow.layer.masksToBounds = false
//        self.backgroundShadow.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).cgColor
//        self.backgroundShadow.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.backgroundShadow.layer.shadowOpacity = 0.5
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
