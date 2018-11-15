//
//  Posting_TableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/6/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Posting_TableViewController: UITableViewController, UITextViewDelegate {
    
    // UIPickerViewDelegate, UIPickerViewDataSource
    

    // Properties
    var specificPosting: Posting!
    var orgName: String!
    var currentQuestionIndex = 0; // keeps track of question to render
    var currentPickerIndex = 0;
    var applicant_answers = [String]()
    
    
    //let dropdown_tvc = Dropdown_Answer_TableViewCell
    //let dropdown_tvc = Dropdown_Answer_TableViewCell(nibName: "Dropdown_Answer_TableViewCell", bundle: nil)
    //dropdown_tvc.Posting_TableViewController = self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.specificPosting.name
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
    
       // reserve some space for answers
        self.applicant_answers.reserveCapacity(self.specificPosting.questions?.count ?? 0)
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 2 {
            return (self.specificPosting.questions?.count ?? 0)
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            if self.specificPosting.questions?.count != 0 {
                return "Questions"
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // status
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! Status_TableViewCell
            
            cell.statusLabel.text = self.specificPosting.status
            
            if self.specificPosting.status == "open" {
                cell.statusLabel.textColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            }
            else {
                cell.statusLabel.textColor = UIColor.red
            }
            
            return cell
        }
        // description
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! Description_TableViewCell
            
            cell.Description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec nec consectetur est, a tincidunt turpis. Maecenas commodo libero ut turpis scelerisque tempor. Curabitur blandit urna mauris, sit amet convallis massa accumsan at. Phasellus molestie fringilla ligula, sed bibendum nisi imperdiet quis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc condimentum, magna id varius pretium, risus nulla dictum justo, sed lobortis urna nunc vel ipsum. Aenean interdum rutrum mollis. Nulla facilisi."//self.specificPosting.job_description
            
            return cell
        }
        // questions
        else if indexPath.section == 2 {
//            if indexPath.row ==
            
            // get the question to render
            let currentQuestion = self.specificPosting.questions?[self.currentQuestionIndex]
            
            // text entry
            if currentQuestion?.type == "text" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "textAnswerCell", for: indexPath) as! TextAnswer_TableViewCell
                
                //cell.configure(questionIn: currentQuestion?.question ?? "no question text", questionIndexIn: self.currentQuestionIndex, controller: self, answerIn: "")
                
                cell.configure(questionIn: currentQuestion?.question ?? "no question text", questionIndexIn: self.currentQuestionIndex, controller: self, answerIn: "", viewIn: self.view)
                
                // move to next question
                self.currentQuestionIndex += 1
                
                return cell
            }
            // dropdown
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownAnswerCell", for: indexPath) as! Dropdown_Answer_TableViewCell
                
                cell.configure(answersIn: currentQuestion?.answers_list ?? [""], questionIn: currentQuestion?.question ?? "no question text", questionIndexIn: self.currentQuestionIndex, controller: self)
                
                // move to next question
                self.currentQuestionIndex += 1
                
                return cell
            }
        }
        // submit button cell
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitCell", for: indexPath) as! Submit_TableViewCell
            
            cell.submitButton.tag = indexPath.row
            cell.submitButton.addTarget(self, action: #selector(self.submitApplication), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    func isEven(_ num: Int) -> Bool {
        return (num % 2 == 0)
    }
    
    // Receiving data from child cells
    func setPickerCellAnswer(forQuestion: Int, selection: String) {
        //print(forQuestion, selection)
        self.specificPosting.questions?[forQuestion].applicant_answer = selection
        print(self.specificPosting.questions!)
    }
    
    func setTextEntry(forQuestion: Int, answer: String) {
        self.specificPosting.questions?[forQuestion].applicant_answer = answer
        print(self.specificPosting.questions!)
    }
    
    @objc func submitApplication() {
        self.specificPosting.questions?.forEach({
            applicant_answers.append($0.applicant_answer!)
        })
        let jsonObject: [String: Any] = [
            "org_name": self.orgName,
            "email": Login_Provider.shared.getUsername(),
            "pos_name": self.title!,
            "answers": applicant_answers,
            "answers_ML": [[-2, Double((Float(arc4random()) / Float(UINT32_MAX)) * 100.0)]]
        ]
        ApplicantAPIManager.submitApplication(data: jsonObject) { (json) in
            print("submit return")
            print(json)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
