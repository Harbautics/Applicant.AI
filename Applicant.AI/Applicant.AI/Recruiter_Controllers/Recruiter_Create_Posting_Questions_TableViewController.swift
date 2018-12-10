//
//  Recruiter_Create_Posting_Questions_TableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/12/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Recruiter_Create_Posting_Questions_TableViewController: UITableViewController {

    // Properties
    var postingTVC: Recruiter_SpecificOrg_TableViewController?
    var postingTVCIdx: Int!
    var questions = [String]()
    var postingName = String()
    var postingTitle: String!
    var orgName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create a New Posting"
        
        self.tableView.reloadData()

        self.showNameAlert()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.determineNextAction))
    }
    
    // after the user is finished:
    // send the API response to create the posting
    override func viewWillDisappear(_ animated: Bool) {
        print("finished creating questions")
        let jsonObject: [String: Any] = [
            "org_name": self.orgName,
            "pos_name": self.postingName,
            "description": "",
            "questions": self.questions
        ]
        print(jsonObject)
        RecruiterAPIManager.createPosting(data: jsonObject) { (json) in
            self.postingTVC?.specificOrganization.postings?[self.postingTVCIdx].id = json["PostingId"].int ?? -1
            print(json)
        }
    }
    
    @objc func determineNextAction() {
        // if we have to set a name
        if self.postingName == "" {
            self.showNameAlert()
        }
        // ready to add questions
        else {
            self.showQuestionAlert()
        }
    }
    
    func showQuestionAlert() {
        //1. Create the alert controller.
        let sheet = UIAlertController(title: "Question Type", message: "Enter the response type of your question", preferredStyle: .actionSheet)
        let text_opt = UIAlertAction(title: "Text", style: .default) { (action) in
            // text action
            //let type = "text"
            //self.question_types.append("text")
            let alert = UIAlertController(title: "New Question", message: "Enter a new question", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = ""
            }
            alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
                if alert!.textFields![0].text != "" {
                    //let q = Question_obj(question_in: alert!.textFields![0].text ?? "no question", type_in: "text")
                    let question = alert!.textFields![0].text ?? "no question"
                    let type = "text"
                    self.addQuestion(newQuestion: "\(question)`\(type)")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        sheet.addAction(text_opt)
        let numerical_opt = UIAlertAction(title: "Numeric", style: .default) { (action) in
            // numerical action
            //self.question_types.append("numeric")
            let alert = UIAlertController(title: "New Question", message: "Enter a new question (numeric answer)", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = ""
                textField.keyboardType = .numberPad
            }
            alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
                if alert!.textFields![0].text != "" {
                    let question = alert!.textFields![0].text ?? "no question"
                    let type = "numeric"
                    self.addQuestion(newQuestion: "\(question)`\(type)")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        sheet.addAction(numerical_opt)
        /*let select_opt = UIAlertAction(title: "Select Option", style: .default) { (action) in
            // select action
            //self.question_types.append("select")
            let alert = UIAlertController(title: "New Question", message: "Enter a new question", preferredStyle: .alert)
            alert.addTextField{ (textField) in
                textField.text = ""
            }
            var q: String?
            alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
                if alert!.textFields![0].text != "" {
                    q = alert!.textFields![0].text ?? "no question"
                    //self.addQuestion(newQuestion: alert!.textFields![0].text ?? "no question")
                }
                let alert2 = UIAlertController(title: "Answer Choices", message: "Enter the answer options, separated by commas", preferredStyle: .alert)
                alert2.addTextField { (textField) in
                    textField.text = ""
                }
                alert2.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert2] (_) in
                    if alert2!.textFields![0].text != "" {
                        //let question = alert!.textFields![0].text ?? "no question"
                        let type = "select"
                        let choices = alert2!.textFields![0].text ?? ""
                        self.addQuestion(newQuestion: "\(q ?? "no question")`\(type)`\(choices)")
                        //self.addQuestion(newQuestion: q ?? "no question", newType: "select", newChoices: alert!.textFields![0].text ?? "")
                    }
                }))
                self.present(alert2, animated: true, completion: nil)
            }))
            
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        sheet.addAction(select_opt)*/
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel actions
        }
        sheet.addAction(cancel)
        
        self.present(sheet, animated: true, completion: nil)
        
        
        /*let alert = UIAlertController(title: "New Question", message: "Enter a new question", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            if alert!.textFields![0].text != "" {
                self.addQuestion(newQuestion: alert!.textFields![0].text ?? "no question")
            }
        }))
        // not allowing cancel right now
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)*/
    }
    
    func showNameAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Name Your Posting", message: "Enter a name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            if alert!.textFields![0].text == "" {
                self.showNameAlert()
            }
            self.setPostingName(nameIn: alert!.textFields![0].text ?? "no name")
        }))
        // not allowing cancel right now
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func showEditAlert(forIndex: Int) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Edit Question", message: "Edit the text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = self.questions[forIndex]
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in
            self.updateQuestion(newText: alert!.textFields![0].text ?? "no name", forIndex: forIndex)
            self.setPostingName(nameIn: alert!.textFields![0].text ?? "no name")
        }))
        // not allowing cancel right now
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func addQuestion(newQuestion: String) {
        self.questions.append(newQuestion)
        self.tableView.reloadData()
        self.postingTVC?.addQuestionToPosting(postingIDX: self.postingTVCIdx, questionText: newQuestion)
    }
    
    func updateQuestion(newText: String, forIndex: Int) {
        self.questions[forIndex] = newText
        self.tableView.reloadData()
        self.postingTVC?.updateQuestionForPosting(postingIDX: self.postingTVCIdx, questionText: newText, questionIDX: forIndex)
    }
    
    func setPostingName(nameIn: String) {
        // alert, capture value, then set name and allow adding questions
        self.postingName = nameIn
        self.title = "New Posting: \(nameIn)"
        self.tableView.reloadData()
        self.postingTVC?.updatePostingName(postingIDX: self.postingTVCIdx, newName: nameIn)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newQuestionCell", for: indexPath)

        if self.questions.count == 0 {
            cell.textLabel?.text = "Tap '+' to create questions"
        }
        else {
            let questions_list = self.questions[indexPath.row].components(separatedBy: "`")
            cell.textLabel?.text = questions_list[0]
        }
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, handler) in
            print("Edit Question")
            self.showEditAlert(forIndex: indexPath.row)
        }
        editAction.backgroundColor = .gray
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            print("Delete Question")
            self.questions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
         configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            self.questions.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            print(self.questions)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    

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
