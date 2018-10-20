//
//  CourseTableViewController.swift
//  dining_app
//
//  Created by Jordan Wolff on 2/28/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    
    var courses = [Course]()
    var atDiningHall: DiningLocation!
    let green = UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0)
    let red = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
    let orange = UIColor(red:1.00, green:0.58, blue:0.00, alpha:1.0)

    
    var notServing = "Not serving "
    var servingMeal = String()
    
    var favoriteMenuItems = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favItem = NSNotification.Name("SavedFavItem")
        NotificationCenter.default.addObserver(self, selector: #selector(CoursesTableViewController.reloadTableView), name: favItem, object: nil)
        
        // get favoriteMenuItems from favorites
        self.favoriteMenuItems = FavoritesManager.shared.getFavoriteMenuItems()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    func reloadTableView() {
        self.favoriteMenuItems = FavoritesManager.shared.getFavoriteMenuItems()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (self.courses.count > 0) {
            return self.courses.count
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.courses.count > 0) {
            return self.courses[section].menuItems.count
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.courses.count > 0) {
            return self.courses[section].name
        }
        else {
            return "No Courses"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseIdentifier", for: indexPath) as! CustomCourseTableViewCell
        
        var textLabel = courses[indexPath.section].menuItems[indexPath.row].name
        
        if self.favoriteMenuItems.contains(courses[indexPath.section].menuItems[indexPath.row].name) {
            textLabel += "  ♥️"
        }
        
        
        cell.Menu_Item_Name.text = textLabel
        
        // set the price if available
        if courses[indexPath.section].menuItems[indexPath.row].sellPrice != nil {
            let priceStr = String(format: "%.2f", courses[indexPath.section].menuItems[indexPath.row].sellPrice!)
            cell.Menu_Item_Price.text = "$" + priceStr
            cell.Menu_Item_Price.textColor = green
            cell.Menu_Item_Price.font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
        }
        else if courses[indexPath.section].menuItems[indexPath.row].infoLabel != nil {
            cell.Menu_Item_Price.text = courses[indexPath.section].menuItems[indexPath.row].infoLabel!
            cell.Menu_Item_Price.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        }
        else if courses[indexPath.section].menuItems[indexPath.row].allergens.count > 0 {
            var allergen_str = "Allergens: "
            let array = courses[indexPath.section].menuItems[indexPath.row].allergens
            for item in array {
                allergen_str += "\(item)"
                if item != array[array.endIndex - 1] {
                    allergen_str += ", "
                }
            }
            cell.Menu_Item_Price.text = allergen_str
            cell.Menu_Item_Price.textColor = red
            cell.Menu_Item_Price.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        }
        else if courses[indexPath.section].menuItems[indexPath.row].traits.count > 0 {
            var trait_str = "Traits: "
            let array = courses[indexPath.section].menuItems[indexPath.row].traits
            for item in array {
                trait_str += "\(item)"
                if item != array[array.endIndex - 1] {
                    trait_str += ", "
                }
            }
            cell.Menu_Item_Price.text = trait_str
            cell.Menu_Item_Price.textColor = orange
            cell.Menu_Item_Price.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        }
        else {
            cell.Menu_Item_Price.text = ""
        }
        
        // if there is no nutrition information to display, don't allow touch
        if (courses[indexPath.section].menuItems[indexPath.row].nutritionInfoArray.count == 0) {
            cell.isUserInteractionEnabled = false;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
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
        if segue.identifier == "CourseToMenuItem" {
            if let MenuItemTVC = segue.destination as? MenuItemTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    MenuItemTVC.selectedMenuItem = courses[indexPath.section].menuItems[indexPath.row]
                    MenuItemTVC.title = courses[indexPath.section].menuItems[indexPath.row].name                    
                }
            }
        }
    }
}
