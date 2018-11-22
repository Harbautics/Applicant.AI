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
    
    var pendingCandidates = [Applicant]()
    var interviewCandidates = [Applicant]()
    var acceptedCandidates = [Applicant]()
    var rejectedCandidates = [Applicant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.specificPosting.name
        
        self.getAndFilterApplicants()
        
        // Notification to listen for when we have Organization data from the API
        let notificationName = NSNotification.Name("UpdateCandidate")
        NotificationCenter.default.addObserver(self, selector: #selector(getAndFilterApplicants), name: notificationName, object: nil)
        
        self.tableView.reloadData()
        
        // Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Updating Applicants...")
        refreshControl.tintColor = globals.colors.main_blue
        refreshControl.addTarget(self, action: #selector(getAndFilterApplicants), for: .valueChanged)
        self.refreshControl = refreshControl

    }
    
    @objc func getAndFilterApplicants() {
        RecruiterAPIManager.getAllApplicantsForPosting(orgName: self.orgName, posName: self.specificPosting.name) { (applicants) in
            self.isLoading = false
            self.specificPosting.applicants = applicants
            
            self.pendingCandidates = applicants.filter({ (applicant) -> Bool in
                return applicant.status == "PENDING"
            })
            self.interviewCandidates = applicants.filter({ (applicant) -> Bool in
                return applicant.status == "INTERVIEW"
            })
            self.acceptedCandidates = applicants.filter({ (applicant) -> Bool in
                return applicant.status == "ACCEPT"
            })
            self.rejectedCandidates = applicants.filter({ (applicant) -> Bool in
                return applicant.status == "REJECT"
            })
            
            // refresh end
            self.tableView.refreshControl?.endRefreshing()
            self.updateTable()
        }
    }
    
    func updateTable() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.specificPosting.applicants?.count == 0 || self.isLoading {
            return 1
        }
        else if section == 0 {
            return self.pendingCandidates.count
        }
        else if section == 1 {
            return self.interviewCandidates.count
        }
        else if section == 2 {
            return self.acceptedCandidates.count
        }
        else if section == 3 {
            return self.rejectedCandidates.count
        }
        return self.specificPosting.applicants?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pending:"
        }
        else if section == 1 {
            return "Interviews:"
        }
        else if section == 2 {
            return "Accepted:"
        }
        else if section == 3 {
            return "Rejected:"
        }
        else {
            return "Error"
        }
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
            var candidate: Applicant
            
            if indexPath.section == 0 {
                candidate = self.pendingCandidates[indexPath.row]
            }
            else if indexPath.section == 1 {
                candidate = self.interviewCandidates[indexPath.row]
            }
            else if indexPath.section == 2 {
                candidate = self.acceptedCandidates[indexPath.row]
            }
            else {
                candidate = self.rejectedCandidates[indexPath.row]
            }
            
            cell.textLabel?.text = candidate.name
            cell.detailTextLabel?.text = "\(candidate.percentageMatch)%"
            cell.isUserInteractionEnabled = true
            cell.accessoryType = .disclosureIndicator
            
            
            if candidate.percentageMatch > 60.0 {
                cell.detailTextLabel?.textColor = globals.colors.green
            }
            else if candidate.percentageMatch > 40.0 {
                cell.detailTextLabel?.textColor = globals.colors.orange
            }
            else {
                cell.detailTextLabel?.textColor = globals.colors.red
            }
            
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
                    
                    var applicant: Applicant
                    
                    if indexPath.section == 0 {
                        applicant = self.pendingCandidates[indexPath.row]
                    }
                    else if indexPath.section == 1 {
                        applicant = self.interviewCandidates[indexPath.row]
                    }
                    else if indexPath.section == 2 {
                        applicant = self.acceptedCandidates[indexPath.row]
                    }
                    else if indexPath.section == 3 {
                        applicant = self.rejectedCandidates[indexPath.row]
                    }
                    else {
                        print("error")
                        applicant = self.specificPosting.applicants?[indexPath.row] ?? Applicant()
                    }
                    
                    applicantTVC.postingID = self.specificPosting.id
                    applicantTVC.specificApplicant = applicant
                }
            }
        }
    }
    

}
