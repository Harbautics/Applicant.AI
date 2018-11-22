//
//  Org_Info_TableViewCell.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/22/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Org_Info_TableViewCell: UITableViewCell {

    @IBOutlet weak var orgType: UILabel!
    @IBOutlet weak var orgLocation: UILabel!
    @IBOutlet weak var orgContact: UIButton!
    @IBOutlet weak var orgInfo: UIButton!
    
    // Properties
    var contact: String!
    var info: String!
    var parent: Applicant_Specific_Org_TableViewController?
    
    // composes message with to field as contact
    @IBAction func tapContact(_ sender: Any) {
        print("tap contact")
        parent?.sendEmail(address: self.contact)
    }
    // opens safari with url string for info
    @IBAction func tapInfo(_ sender: Any) {
        print("tap info")
        guard let url = URL(string: info) else { return }
        UIApplication.shared.open(url)
    }
    
    func configure(contactIn: String, infoIn: String, parent: Applicant_Specific_Org_TableViewController) {
        
        self.parent = parent
        
        self.contact = contactIn
        
        if !infoIn.contains("http://") || !infoIn.contains("https://") {
            self.info = "http://\(infoIn)"
        }
        else {
            self.info = infoIn
        }
        self.becomeFirstResponder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
