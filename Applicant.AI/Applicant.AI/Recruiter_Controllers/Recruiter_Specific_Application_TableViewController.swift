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
    var postingID: Int! // the ID of the posting the applicant submitted to
    var appStatus = String() // PENDING, REJECT, ACCEPT, INTERVIEW
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = specificApplicant.name
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Action", style: .plain, target: self, action: #selector(self.showActions))
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
    
    func postNotification() {
        let notificationName = NSNotification.Name("UpdateCandidate")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func acceptCandidate() {
        print("accepting candidate...")
        self.specificApplicant.status = "ACCEPT"
        RecruiterAPIManager.updateApplicantStatus(status: "ACCEPT", applicantEmail: self.specificApplicant.email, postId: self.postingID) { (json) in
            print("Update status for accepted returned\n:", json)
            // post a notification
            self.postNotification()
        }
        self.tableView.reloadData()
    }
    func rejectCandidate() {
        print("rejecting candidate...")
        self.specificApplicant.status = "REJECT"
        RecruiterAPIManager.updateApplicantStatus(status: "REJECT", applicantEmail: self.specificApplicant.email, postId: self.postingID) { (json) in
            print("Update status for rejected returned\n:", json)
            // post a notification
            self.postNotification()
        }
        self.tableView.reloadData()
    }
    func grantInterview() {
        print("granting interview...")
        self.specificApplicant.status = "INTERVIEW"
        RecruiterAPIManager.updateApplicantStatus(status: "INTERVIEW", applicantEmail: self.specificApplicant.email, postId: self.postingID) { (json) in
            print("Update status for interview returned\n:", json)
            // post a notification
            self.postNotification()
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return  self.specificApplicant.questions.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // status
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recruiter_info_status_identifier", for: indexPath)
            cell.textLabel?.text = "Status:"
            cell.detailTextLabel?.text = self.specificApplicant.status
            return cell
        }
        // questions and answers
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recruiter_info_identifier", for: indexPath) as! Question_Answer_TableViewCell

            cell.questionLabel.text = self.specificApplicant.questions[indexPath.row].question
            cell.answerLabel.text = self.specificApplicant.questions[indexPath.row].applicant_answer
            
            return cell
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
