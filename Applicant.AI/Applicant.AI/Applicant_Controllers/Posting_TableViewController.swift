//
//  Posting_TableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/6/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit
// For spinner
extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

class Posting_TableViewController: UITableViewController, UITextViewDelegate {

    // Properties
    var specificPosting: Posting!
    var orgName: String!
    var currentQuestionIndex = 0; // keeps track of question to render
    var currentPickerIndex = 0;
    var applicant_answers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = self.specificPosting.name
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
    
       // reserve some space for answers
        self.applicant_answers.reserveCapacity(self.specificPosting.questions?.count ?? 0)
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return (self.specificPosting.questions?.count ?? 0)
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Information"
        }
        else if section == 2 {
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
            
            if self.specificPosting.status == "OPEN" {
                cell.statusLabel.textColor = globals.colors.green
            }
            else if self.specificPosting.status == "CLOSED" {
                cell.statusLabel.textColor = globals.colors.red
            }
            
            cell.isUserInteractionEnabled = false
            
            return cell
        }
        // description
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! Description_TableViewCell
            
            cell.Description.text = self.specificPosting.job_description
            
            cell.isUserInteractionEnabled = false
            
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
    
    // Receiving data from child cells
    func setPickerCellAnswer(forQuestion: Int, selection: String) {
        self.specificPosting.questions?[forQuestion].applicant_answer = selection
    }
    
    // Receiving data from child cells
    func setTextEntry(forQuestion: Int, answer: String) {
        self.specificPosting.questions?[forQuestion].applicant_answer = answer
    }
    
    // Shows error alert if empty text field
    func showErrorAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Incomplete Application", message: "Please answer all questions", preferredStyle: .alert)
        
        // 2. Add action to clear alert
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
        }))
        
        // 3. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    func showSuccessAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Success", message: "Your application has been submitted!\nPlease do not submit again.", preferredStyle: .alert)
        
        // 2. Add action to clear alert
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            self.performUnwind()
        }))
        
        // 3. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    // Function to submit question to API
    @objc func submitApplication() {
        self.specificPosting.questions?.forEach({
            applicant_answers.append($0.applicant_answer!)
        })
        
        // check to see if answered all questions
        for item in self.applicant_answers {
            if item == "" {
                self.applicant_answers.removeAll()
                self.showErrorAlert()
                return
            }
        }
        
        let jsonObject: [String: Any] = [
            "org_name": self.orgName,
            "email": Login_Provider.shared.getUsername(),
            "pos_name": self.specificPosting.name,
            "answers": applicant_answers,
            "answers_ML": [[-2, Double((Float(arc4random()) / Float(UINT32_MAX)) * 100.0)]]
        ]
        
        // TODO: show spinner saying submitting
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        ApplicantAPIManager.submitApplication(data: jsonObject) { (json) in
            // post a notification
            let notificationName = NSNotification.Name("SubmittedApplication")
            NotificationCenter.default.post(name: notificationName, object: nil)
            // TODO: stop spinner, show success alert, segue back
            UIViewController.removeSpinner(spinner: sv)
            self.showSuccessAlert()
        }
    }
    
    // Send us back to the previous controller
    func performUnwind() {
        self.performSegue(withIdentifier: "unwindToSpecific", sender: self)
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
