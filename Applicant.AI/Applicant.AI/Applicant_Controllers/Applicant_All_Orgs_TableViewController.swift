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
    var applied_organizations = [Organization]()
    var filtered_organizations = [Organization]()
    
    override func viewDidLoad() {
        print("org view loading")
        
        // Access the organizations provider (even though there's no data there) in order to create the global instance
        self.all_organizations = Organizations_Provider.shared.organizations
        
        // Notification to listen for when we have Organization data from the API
        let notificationName = NSNotification.Name("OrganizationsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: notificationName, object: nil)
        // Matching applications
        let notificationName2 = NSNotification.Name("MatchedOrgsDone")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: notificationName2, object: nil)
        
        // Force a match, which will reload -- this really only matters on log-outs / log ins
        Organizations_Provider.shared.matchOrganizations()
        
        // Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation =  false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Org name, ID, Location"
        navigationItem.title = "Organizations"
        super.viewDidLoad()
        
        // Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Updating Organizations...")        
        refreshControl.tintColor = globals.colors.main_blue
        refreshControl.addTarget(self, action: #selector(refreshAPICall), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Force Match -- coming back from other controller
        // Also when logging in as different user!
        print("appearing")
        Organizations_Provider.shared.refreshOrganizations()
        Organizations_Provider.shared.refreshSubmissions()
    }
    
    @objc func refreshAPICall() {
        print("refreshing orgs")
        Organizations_Provider.shared.refreshOrganizations()
        Organizations_Provider.shared.refreshSubmissions()
    }

    // The callback function when we have organizations data
    @objc func reloadTableView() {
        print("reloading...")
        // pull data from global shared
        self.all_organizations = Organizations_Provider.shared.organizations
        self.applied_organizations = self.all_organizations.filter({ (org) -> Bool in
            return org.userApplied
        })
        // refresh end
        self.tableView.refreshControl?.endRefreshing()
        // don't forget to reload the table view
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }
        else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filtered_organizations.count
        }
        else if section == 0 {
            return applied_organizations.count
        }
        else {
            return all_organizations.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return "Search Results"
        }
        else if (section == 0) {
            return "Your Organizations"
        }
        else if (section == 1) {
            return "Discover Organizations"
        }
        else {
            return "Error"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "applicant_org_cell", for: indexPath) as! Organization_TableViewCell
        
        //cell.configure()
        
        // Search filter or normal
        var org: Organization!
        if searchController.isActive && searchController.searchBar.text != "" {
            org = filtered_organizations[indexPath.row]
        }
        else if indexPath.section == 0 {
            org = applied_organizations[indexPath.row]
        }
        else {
            org = all_organizations[indexPath.row]
        }
        
        // Name, Location
        cell.organizationName.text = org.name
        cell.organizationLocation.text = org.location
        cell.organizationLocation.textColor = UIColor.lightGray
        
        // Type
        let type = org.type
        if type == "School Club" {
            cell.iconImage.image = UIImage(named: "school")
        }
        else if type == "Professional" {
            cell.iconImage.image = UIImage(named: "professional")
        }
        else if type == "Social" {
            cell.iconImage.image = UIImage(named: "social")
        }
        else if type == "Business" {
            cell.iconImage.image = UIImage(named: "business-2")
        }
        else {
            print(type)
        }
        cell.iconImage.contentMode = .scaleAspectFit
        
        return cell
    }
    
    // search functions
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        var results = [Organization]()
        for item in self.all_organizations {
            let searchID = String(item.id)
            if item.name.localizedCaseInsensitiveContains(searchText) || searchID.localizedCaseInsensitiveContains(searchText)
            || item.location.localizedCaseInsensitiveContains(searchText){
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
                    else if indexPath.section == 0 {
                        specific_Org_TVC.specificOrg = self.applied_organizations[indexPath.row]
                    }
                    else {
                        specific_Org_TVC.specificOrg = self.all_organizations[indexPath.row]
                    }
                }
            }
        }
    }
    

}
