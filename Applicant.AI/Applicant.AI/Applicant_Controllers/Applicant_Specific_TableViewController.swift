//
//  Applicant_Specific_TableViewController.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 10/20/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import UIKit

class Applicant_Specific_TableViewController: UITableViewController {

    var specificApplication: Application!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = self.specificApplication.name
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
            return self.specificApplication.questions.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "applicant_info_status_identifier", for: indexPath)
            cell.textLabel?.text = "Status:"
            cell.detailTextLabel?.text = self.specificApplication.status
            
            if self.specificApplication.status == "ACCEPT" {
                cell.detailTextLabel?.textColor = globals.colors.green
            }
            else if self.specificApplication.status == "REJECT" {
                cell.detailTextLabel?.textColor = globals.colors.red
            }
            
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "applicant_info_identifier", for: indexPath) as! Question_Answer_TableViewCell
            cell.questionLabel.text = self.specificApplication.questions[indexPath.row].question
            cell.answerLabel.text = self.specificApplication.questions[indexPath.row].applicant_answer
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
