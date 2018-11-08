//
//  TextAnswer_TableViewCell.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/7/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class TextAnswer_TableViewCell: UITableViewCell {

    @IBOutlet weak var textEntryArea: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
    }

}
