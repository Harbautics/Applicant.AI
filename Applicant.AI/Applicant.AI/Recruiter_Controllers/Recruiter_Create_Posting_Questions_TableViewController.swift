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
        // TODO: send API POST to create the posting
        // send: orgname & postitionname & list of questions
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
        let alert = UIAlertController(title: "New Question", message: "Enter a new question", preferredStyle: .alert)
        
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
        self.present(alert, animated: true, completion: nil)
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
            cell.textLabel?.text = self.questions[indexPath.row]
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
