//
//  Recruiter_SpecificOrg_TableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/12/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Recruiter_SpecificOrg_TableViewController: UITableViewController {

    var specificOrganization: Organization!
    var createPostingIDX = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.specificOrganization.name
        
        print(self.specificOrganization.id)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.createPosting))
    }
    
    @objc func createPosting() {
        self.specificOrganization.postings?.append(Posting())
        self.createPostingIDX = (self.specificOrganization.postings?.count)! - 1
        
        self.tableView.reloadData()
        
        // segue to new controller, where they can add questions
        self.performSegue(withIdentifier: "recruiter_create_questions", sender: self)
    }
    
    // function for creation controller to add a question to the posting
    func addQuestionToPosting(postingIDX: Int, questionText: String) {
        self.specificOrganization.postings?[postingIDX].questions?.append(Question(description_in: "none", question_in: questionText, applicant_answer_in: "", type_in: "text", answer_list_in: [""]))
    }
    // function for creation controller to update a question for the posting
    func updateQuestionForPosting(postingIDX: Int, questionText: String, questionIDX: Int) {
        self.specificOrganization.postings?[postingIDX].questions?[questionIDX].question = questionText
    }
    // function for creation controller to update posting name
    func updatePostingName(postingIDX: Int, newName: String) {
        self.specificOrganization.postings?[postingIDX].name = newName
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.specificOrganization.postings?.count == 0 {
            return 1
        }
        return self.specificOrganization.postings?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recruiterPostingCell", for: indexPath)

        if self.specificOrganization.postings?.count == 0 {
            cell.textLabel?.text = "Tap the '+' to create a posting"
            cell.isUserInteractionEnabled = false
        }
        else {
            cell.textLabel?.text = self.specificOrganization.postings?[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            cell.isUserInteractionEnabled = true
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "recruiter_create_questions" {
            if let createQuestionsTVC = segue.destination as? Recruiter_Create_Posting_Questions_TableViewController {
                createQuestionsTVC.postingTVC = self
                createQuestionsTVC.postingTVCIdx = self.createPostingIDX
                createQuestionsTVC.orgName = self.specificOrganization.name
                let backItem = UIBarButtonItem()
                backItem.title = "Finish"
                navigationItem.backBarButtonItem = backItem
            }
        }
        
        if segue.identifier == "recruiterPostingsToSpecific" {
            if let specificPostingTVC = segue.destination as? Recruiter_Postings_TableViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    specificPostingTVC.specificPosting = self.specificOrganization.postings?[indexPath.row]
                    specificPostingTVC.orgName = self.specificOrganization.name
                    let backItem = UIBarButtonItem()
                    backItem.title = self.title
                    navigationItem.backBarButtonItem = backItem
                }
            }
        }
        
    }
    

}
