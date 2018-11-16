//
//  ApplicantOrgTableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/20/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit
import Foundation

extension Applicant_All_Orgs_TableViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}


class Applicant_All_Orgs_TableViewController: UITableViewController, UISearchBarDelegate {

    // Properties
    let searchController = UISearchController(searchResultsController: nil)
    var all_organizations = [Organization]()
    var filtered_organizations = [Organization]()
    
    override func viewDidLoad() {
        print("org view loading")
        
        // Access the organizations provider (even though there's no data there) in order to create the global instance
        self.all_organizations = Organizations_Provider.shared.organizations
        
        // Notification to listen for when we have Organization data from the API
        let notificationName = NSNotification.Name("OrganizationsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(Applicant_All_Orgs_TableViewController.reloadTableView), name: notificationName, object: nil)
        
        // Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation =  false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Enter organization name or ID"
        self.title = "Organizations"
        super.viewDidLoad()
    }

    // The callback function when we have organizations data
    @objc func reloadTableView() {
        // pull data from global shared
        self.all_organizations = Organizations_Provider.shared.organizations
        // don't forget to reload the table view
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filtered_organizations.count
        }
        else {
            return all_organizations.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Discover Organizations"
        }
        else if (section == 1) {
            return "Your Organizations"
        }
        else {
            return "Error"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.textLabel?.text = filtered_organizations[indexPath.row].name
        }
        else {
            cell.textLabel?.text = all_organizations[indexPath.row].name
        }
        
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    // search functions
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        var results = [Organization]()
        for item in self.all_organizations {
            if item.name.localizedCaseInsensitiveContains(searchText) || item.id.localizedCaseInsensitiveContains(searchText) {
                results.append(item)
            }
        }
        self.filtered_organizations = results
        self.tableView.reloadData()
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
        if segue.identifier == "allOrgsToSpecific" {
            if let specific_Org_TVC = segue.destination as? Applicant_Specific_Org_TableViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    if searchController.isActive && searchController.searchBar.text != "" {
                        specific_Org_TVC.specificOrg = self.filtered_organizations[indexPath.row]
                    }
                    else {
                        specific_Org_TVC.specificOrg = self.all_organizations[indexPath.row]
                    }
                }
            }
        }
    }
    

}
