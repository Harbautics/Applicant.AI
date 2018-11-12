//
//  TextAnswer_TableViewCell.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/7/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class TextAnswer_TableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textEntryArea: UITextView!
    @IBOutlet weak var question: UILabel!
    
    // Properties
    var questionIndex: Int!
    var postingTVC: Posting_TableViewController?
    var answer = String()
    var displayedQuestion = String()
    
    
    // Sets the question label and the text entry field
    func configure(questionIn: String, questionIndexIn: Int, controller: Posting_TableViewController, answerIn: String) {
        self.postingTVC = controller
        self.questionIndex = questionIndexIn
        self.answer = answerIn
        self.displayedQuestion = questionIn
        
        // set the prompt and placeholder
        self.question.text = questionIn
        
        // set the default answer
        postingTVC?.setTextEntry(forQuestion: self.questionIndex, answer: self.answer)
    }
    
    // sends the data back to the controller
    func textViewDidChange(_ textView: UITextView) {
        postingTVC?.setTextEntry(forQuestion: self.questionIndex, answer: self.textEntryArea.text)
    }
    
    // Default functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textEntryArea.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
