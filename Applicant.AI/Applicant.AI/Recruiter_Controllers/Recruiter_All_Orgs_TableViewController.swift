//
//  Recruiter_All_Orgs_TableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/12/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Recruiter_All_Orgs_TableViewController: UITableViewController {

    // Properties
    var orgs = [Organization]()
    var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(logoutPrompt))

        // Make API Call
        RecruiterAPIManager.getAllOrganizationsForRecruiter { (newOrg) in
            self.isLoading = false
            self.orgs.append(newOrg)
            
            if (newOrg.name == "default") {
                self.orgs.removeAll()
            }
            
            // add plus button to controller if no orgs
            if self.orgs.count == 0 {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAlert))
            }
            
            self.updateTable()
        }
    }
    
    // shows the alert to collect the org name
    @objc func showAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "New organization", message: "Enter a name for your organization", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "org name"
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "location"
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Info Link: leave out http://"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Business, School, Professional, or Social"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            self.createOrg(orgName: alert!.textFields![0].text ?? "no name", location: alert!.textFields![1].text ?? "no location",
                           link: alert!.textFields![2].text ?? "no link", type: alert!.textFields![3].text ?? "no type")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("cancelled")
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func createOrg(orgName: String, location: String, link: String, type: String) {
        print(orgName)
        print(location)
        print(link)
        
        let newOrg = Organization(name_in: orgName)
        self.orgs.append(newOrg)
        
        // hide the plus button
        self.navigationItem.leftBarButtonItem = nil
        
        // make sure we're doing "School" and not "school" or "SCHOOL"
        var newType = type.lowercased().capitalized
        //newType = capitalizeString(str: newType)
        // default for DB sanity
        if (newType != "School Club" && newType != "Professional" && newType != "Business" && newType != "Social") {
            newType = "Professional"
        }
        
        let jsonObject: [String: String] = [
            "org_name": orgName,
            "email": Login_Provider.shared.getUsername(),
            "location": location,
            "link": link,
            "org_type": newType,
            "description": ""
        ]
        self.isLoading = true
        self.updateTable()
        RecruiterAPIManager.createOrganization(data: jsonObject) { (json) in
            print("creating org post request")
            print(json)
            // set the orgid
            if let orgID = json["OrganizationId"].int {
                self.orgs[0].id = orgID
            }
            self.isLoading = false
            self.updateTable()
        }        
    }
    
    func updateTable() {
        self.tableView.reloadData()
    }
    
//    func capitalizeString(str: String) -> String {
//        return (str.prefix(1).capitalized + str.dropFirst()).capitalized
//    }
    
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
    
    @objc func logout() {
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
        if self.orgs.count == 0 || self.isLoading {
            return 1
        }
        else {
            return self.orgs.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recruiter_organization_cell", for: indexPath)
        
        if self.isLoading  {
            cell.textLabel?.text = "Loading..."
            cell.isUserInteractionEnabled = false
        }
        else if self.orgs.count == 0 {
            cell.textLabel?.text = "Tap the '+' to create a new organization"
            cell.isUserInteractionEnabled = false
        }
        else {
            cell.textLabel?.text = self.orgs[indexPath.row].name
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
        if segue.identifier == "recruiter_all_orgs_to_specific" {
            if let specificTVC = segue.destination as? Recruiter_SpecificOrg_TableViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    specificTVC.specificOrganization = self.orgs[indexPath.row]
                }
            }
        }
    }
    

}
