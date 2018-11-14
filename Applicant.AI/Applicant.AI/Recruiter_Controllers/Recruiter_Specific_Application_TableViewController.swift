//
//  Recruiter_Specific_Application_TableViewController.swift
//  
//
//  Created by Jordan Wolff on 11/12/18.
//

import UIKit

class Recruiter_Specific_Application_TableViewController: UITableViewController {

    // Properties
    var specificApplicant: Applicant! // the person who submitted the application
    var applicantAnswers: [Question]? // the list of questions (with answers) for the person's application
    var postingID: Int! // the ID of the posting the applicant submitted to
    var appStatus = String()
    var isLoading = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Make the API request to get the questions and answers for the given application
        // need the applicants status too
        // callback:
        self.isLoading = false
        
        self.title = specificApplicant.name
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Action", style: .plain, target: self, action: #selector(self.showActions))
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.showActions))
    }
    
    @objc func showActions() {
        print("clicked actions")
        // Show action sheet
        // 1. Interview
        // 2. Accept
        // 3. Reject
        
        let alertController = UIAlertController(title: "Actions", message: "Change the application status for this applciation", preferredStyle: .actionSheet)
        
        let interviewButton = UIAlertAction(title: "Grant Interview", style: .default, handler: { (action) -> Void in
            self.grantInterview()
        })
        
        let acceptButton = UIAlertAction(title: "Accept Candidate", style: .default, handler: { (action) -> Void in
            self.acceptCandidate()
        })
        
        let rejectButton = UIAlertAction(title: "Reject Candidate", style: .default, handler: { (action) -> Void in
            self.rejectCandidate()
        })
        let doneButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        
        alertController.addAction(interviewButton)
        alertController.addAction(acceptButton)
        alertController.addAction(rejectButton)
        alertController.addAction(doneButton)

        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    // TODO: link functions to API
    func acceptCandidate() {
        print("accepting candidate...")
        self.appStatus = "accepted"
    }
    func rejectCandidate() {
        print("rejecting candidate...")
        self.appStatus = "rejected"
    }
    func grantInterview() {
        print("granting interview...")
        self.appStatus = "interview"
    }

    // TODO: render data related to candidate
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.isLoading {
            return 1
        }
        else {
            return 2 // status + questions
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLoading {
            return 1
        }
        else {
            return self.applicantAnswers?.count ?? 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recruiterApplicantInfo", for: indexPath)

        if self.isLoading {
            cell.textLabel?.text = "Loading..."
        }
        // status
        else if indexPath.section == 0 {
            cell.textLabel?.text = self.appStatus
        }
        // questions and answers
        else if indexPath.section == 1 {
            cell.textLabel?.text = self.applicantAnswers?[indexPath.row].question
            cell.detailTextLabel?.text = self.applicantAnswers?[indexPath.row].applicant_answer
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
