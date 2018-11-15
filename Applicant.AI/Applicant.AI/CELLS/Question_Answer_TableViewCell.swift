//
//  Question_Answer_TableViewCell.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/15/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Question_Answer_TableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
