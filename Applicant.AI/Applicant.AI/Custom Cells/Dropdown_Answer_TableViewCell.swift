//
//  Dropdown_Answer_TableViewCell.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/7/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Dropdown_Answer_TableViewCell: UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.answers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.answers[row]
    }
    

    @IBOutlet weak var answerPicker: UIPickerView!
    
    // Potential Answers
    var answers = [String]()
    
    func configure(answersIn: [String]) {
        self.answers = answersIn
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.answerPicker.delegate = self
        self.answerPicker.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
