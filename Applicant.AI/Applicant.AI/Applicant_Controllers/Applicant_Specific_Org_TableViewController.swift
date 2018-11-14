//
//  Applicant_Specific_Org_TableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/5/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Applicant_Specific_Org_TableViewController: UITableViewController {

    var specificOrg: Organization!
    
    
    override func viewDidLoad() {
        self.title = specificOrg.name
                        
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // members, postings
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.specificOrg.postings?.count ?? 0
        }
        else if section == 1 {
            return self.specificOrg.members?.count ?? 0
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Positions"
        }
        else if section == 1 {
            return "Members"
        }
        else {
            return "Extra"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Posting
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postingCell", for: indexPath)
            cell.textLabel?.text = specificOrg.postings?[indexPath.row].name ?? "no name"
            cell.detailTextLabel?.text = specificOrg.postings?[indexPath.row].status ?? "no status"
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        // Member
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
            cell.textLabel?.text = specificOrg.members?[indexPath.row].name ?? "no member name"
            cell.detailTextLabel?.text = ""
            
            cell.isUserInteractionEnabled = false
            
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "specificOrgToPosting" {
            if let postingTVC = segue.destination as? Posting_TableViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    postingTVC.specificPosting = self.specificOrg.postings?[indexPath.row]
                    postingTVC.orgName = self.specificOrg.name
                }
            }
        }
    }
    

}
