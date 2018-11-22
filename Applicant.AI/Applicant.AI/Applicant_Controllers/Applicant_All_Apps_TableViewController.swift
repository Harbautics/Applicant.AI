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

        
        self.applications = Organizations_Provider.shared.apps
        
        // updates so we can update the view
        let notificationName = NSNotification.Name("SubmissionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: notificationName, object: nil)
        
        // updates so we can update the view
        let notificationName2 = NSNotification.Name("SubmittedApplication")
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: notificationName2, object: nil)
        
        // Logout button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(logoutPrompt))
        navigationItem.title = "Applications"
        
        self.tableView.reloadData()
        
        // Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Updating Applications...")
        refreshControl.tintColor = globals.colors.main_blue
        refreshControl.addTarget(self, action: #selector(refreshAPICall), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func refreshAPICall() {
        Organizations_Provider.shared.refreshSubmissions()
    }
    
    @objc func updateTable() {
        self.applications = Organizations_Provider.shared.apps
        print("back here")
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    @objc func logoutPrompt() {
        let alert = UIAlertController(title: "Log Out", message: "You will be logged out of Applicant.AI", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("cancelled")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logout() {
        print("logging out...")
        Login_Provider.shared.clearDefaults()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginScreen = storyBoard.instantiateViewController(withIdentifier: "Login_ViewController")
        loginScreen.modalTransitionStyle = .flipHorizontal
        self.present(loginScreen, animated: true, completion: nil)
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
