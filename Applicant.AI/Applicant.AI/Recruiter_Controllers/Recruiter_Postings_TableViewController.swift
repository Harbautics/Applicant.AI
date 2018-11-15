//
//  Recruiter_Postings_TableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/12/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Recruiter_Postings_TableViewController: UITableViewController {

    // Properties
    var specificPosting: Posting!
    var isLoading = true
    var orgName = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.specificPosting.name
        
        RecruiterAPIManager.getAllApplicantsForPosting(orgName: self.orgName, posName: self.specificPosting.name) { (applicants) in
            self.isLoading = false
            self.specificPosting.applicants = applicants
            self.updateTable()
        }
        
        self.tableView.reloadData()

    }
    
    func updateTable() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.specificPosting.applicants?.count == 0 || self.isLoading {
            return 1
        }
        return self.specificPosting.applicants?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recruiterApplicantCell", for: indexPath)

        if self.isLoading {
            cell.textLabel?.text = "Loading..."
            cell.detailTextLabel?.text = ""
            cell.isUserInteractionEnabled = false
        }
        else if self.specificPosting.applicants?.count == 0 {
            cell.textLabel?.text = "No Applicants Yet"
            cell.detailTextLabel?.text = ""
            cell.isUserInteractionEnabled = false
        }
        else {
            cell.textLabel?.text = self.specificPosting.applicants?[indexPath.row].name
            cell.detailTextLabel?.text = "\(self.specificPosting.applicants?[indexPath.row].percentageMatch ?? 0.0)%"
            cell.isUserInteractionEnabled = true
            cell.accessoryType = .disclosureIndicator
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
        if segue.identifier == "recruiterAllApplicantsToSpecific" {
            if let applicantTVC = segue.destination as? Recruiter_Specific_Application_TableViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    applicantTVC.postingID = self.specificPosting.id
                    applicantTVC.specificApplicant = self.specificPosting.applicants?[indexPath.row]
                }
            }
        }
    }
    

}
