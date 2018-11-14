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
    var view: UIView!
    
    
    // Sets the question label and the text entry field
    func configure(questionIn: String, questionIndexIn: Int, controller: Posting_TableViewController, answerIn: String, viewIn: UIView) {
        self.postingTVC = controller
        self.questionIndex = questionIndexIn
        self.answer = answerIn
        self.displayedQuestion = questionIn
        self.view = viewIn
        
        // set the prompt and placeholder
        self.question.text = questionIn
        
        // set the default answer
        postingTVC?.setTextEntry(forQuestion: self.questionIndex, answer: self.answer)
    
        // the toolbar - with the DONE editing - is configured in setSelected
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
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        //init toolbar
        //let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.width, height: 30))
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        //let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction),
        
        //let doneBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: #selector(self.doneButtonAction))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.textEntryArea.inputAccessoryView = toolbar
        self.textEntryArea.inputAccessoryView = toolbar
    }
}
