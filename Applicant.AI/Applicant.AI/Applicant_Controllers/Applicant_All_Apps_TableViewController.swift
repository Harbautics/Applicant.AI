//
//  ApplicantAppTableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/20/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Applicant_All_Apps_TableViewController: UITableViewController {
    
    var applications = [Application]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApplicantAPIManager.getAllSubmissions { (applicationsIn) in
            self.applications = applicationsIn
            self.tableView.reloadData()
        }
        
        // updates so we can update the view
        let notificationName = NSNotification.Name("SubmittedApplication")
        NotificationCenter.default.addObserver(self, selector: #selector(Applicant_All_Apps_TableViewController.updateTable), name: notificationName, object: nil)
        
        self.title = "Applications"
        self.tableView.reloadData()
        
        // Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Updating Applications...")
        refreshControl.tintColor = globals.colors.main_blue
        refreshControl.addTarget(self, action: #selector(refreshAPICall), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func refreshAPICall() {
        ApplicantAPIManager.getAllSubmissions { (applicationsIn) in
            self.applications = applicationsIn
            // refresh end
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @objc func updateTable() {
        ApplicantAPIManager.getAllSubmissions { (applicationsIn) in
            self.applications = applicationsIn
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.applications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "app_cell_identifier", for: indexPath)

        cell.textLabel?.text = self.applications[indexPath.row].name
        cell.detailTextLabel?.text = self.applications[indexPath.row].status
        
        if self.applications[indexPath.row].status == "ACCEPT" {
            cell.detailTextLabel?.textColor = globals.colors.green
        }
        else if self.applications[indexPath.row].status == "REJECT" {
            cell.detailTextLabel?.textColor = globals.colors.red
        }
        
        cell.accessoryType = .disclosureIndicator

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
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "all_apps_to_specific_app" {
            if let specific_app_TVC = segue.destination as? Applicant_Specific_TableViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    specific_app_TVC.specificApplication = self.applications[indexPath.row]
                    specific_app_TVC.title = "Testing title" //sampleData[indexPath.row].position_name
                }
            }
        }
    }
}
