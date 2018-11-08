//
//  Dropdown_Answer_TableViewCell.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/7/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Dropdown_Answer_TableViewCell: UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var answerPicker: UIPickerView!
    
    // Potential Answers
    var answers = [String]()
    var questionIndex: Int!
    var postingTVC: Posting_TableViewController?
    
    func configure(answersIn: [String], questionIndexIn: Int, controller: Posting_TableViewController) {
        self.answers = answersIn
        self.questionIndex = questionIndexIn
        self.postingTVC = controller
        
        // send the default choice initially back the controller
        if self.answers.count != 0 {
            postingTVC?.setPickerCellAnswer(forQuestion: self.questionIndex, selection: self.answers[0])
        }
        else {
            postingTVC?.setPickerCellAnswer(forQuestion: self.questionIndex, selection: "")
        }
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

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.answers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.answers[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let choice = self.answers[row]
        //print(choice)
        postingTVC?.setPickerCellAnswer(forQuestion: self.questionIndex, selection: choice)
    }
    
}
