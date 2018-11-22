//
//  Applicant_Specific_Org_TableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/5/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit
import MessageUI

class Applicant_Specific_Org_TableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var specificOrg: Organization!
    
    
    override func viewDidLoad() {
        navigationItem.title = specificOrg.name
                        
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // info, members, postings
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            if self.specificOrg.postings?.count == 0 {
                return 1
            }
            return self.specificOrg.postings!.count
        }
        else if section == 2 {
            if self.specificOrg.members?.count == 0 {
                return 1
            }
            return self.specificOrg.members!.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Info"
        }
        else if section == 1 {
            return "Postings"
        }
        else if section == 2 {
            return "Members"
        }
        else {
            return "Extra"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Info
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "orgInfoCell", for: indexPath) as! Org_Info_TableViewCell
            
            cell.configure(contactIn: self.specificOrg.contact, infoIn: self.specificOrg.infoLink, parent: self)
            
            cell.orgType.text = self.specificOrg.type
            cell.orgLocation.text = self.specificOrg.location
            
            return cell
        }
        
        
        // Posting
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postingCell", for: indexPath)
            
            let ID = Int(self.specificOrg.id) ?? -2
            
            if self.specificOrg.postings?.count == 0 {
                cell.textLabel?.text = "No Postings Yet"
                cell.detailTextLabel?.text = ""
                cell.isUserInteractionEnabled = false
            }
            else {
                cell.textLabel?.text = specificOrg.postings?[indexPath.row].name ?? "no name"
                
                if Organizations_Provider.shared.didUserApply(ID: ID) {
                    cell.detailTextLabel?.text = "APPLIED ✅"
                    cell.accessoryType = .none
                    cell.isUserInteractionEnabled = false
                }
                else {
                    cell.detailTextLabel?.text = specificOrg.postings?[indexPath.row].status ?? "no status"
                    cell.accessoryType = .disclosureIndicator
                    cell.isUserInteractionEnabled = true
                }
            }
            
            

            return cell
        }
        // Member
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
            
            if self.specificOrg.members?.count == 0 {
                cell.textLabel?.text = "No Members Yet"
                cell.detailTextLabel?.text = ""
            }
            else {
                cell.textLabel?.text = specificOrg.members?[indexPath.row].name ?? "no member name"
                cell.detailTextLabel?.text = ""
            }
            
            cell.isUserInteractionEnabled = false

            
            return cell
        }
    }
    
    func configureMailController(address: String) -> MFMailComposeViewController {
        
        print(address)
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        
        var recipients = [String]()
        recipients.append(address)
        mailVC.setToRecipients(recipients)
        mailVC.setSubject("Inquiring About \(self.specificOrg.name)")
        
        return mailVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendEmail(address: String) {
        let mailVC = configureMailController(address: address)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailVC, animated: true, completion: nil)
        }
        else {
            self.showMailError()
        }
    }
    
    func showMailError() {
        print("mail error")
        let alert = UIAlertController(title: "Mail Error", message: "Mail is not supported on your device", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
        }))        
        self.present(alert, animated: true, completion: nil)
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
    
    // UNWIND SEGUE
    @IBAction func unwindToSpecific(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }

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
