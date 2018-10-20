//
//  FavoritesTableViewController.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/2/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class FavoritesTableViewController: UITableViewController {

    // Properties
    var favoriteDiningHalls = [String]()
    var favoriteMenuItems = [String]()
    
    var favoriteMenuItemsServedToday = [MenuItem]()
    var favoriteMenuItemsServedTodayStrs = [String]()
    
    
    // Outlets
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    // Actions
    @IBAction func clear(_ sender: UIBarButtonItem) {
            self.clear()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.favoriteDiningHalls = FavoritesManager.shared.favoriteLocationsStr
        self.favoriteMenuItems = FavoritesManager.shared.favoriteMenuItemsStr
        
        // subscribe to notifications
        let favLocation = NSNotification.Name("SavedFavLocation")
        NotificationCenter.default.addObserver(self, selector: #selector(FavoritesTableViewController.reloadTableView), name: favLocation, object: nil)
        
        let favItem = NSNotification.Name("SavedFavItem")
        NotificationCenter.default.addObserver(self, selector: #selector(FavoritesTableViewController.reloadTableView), name: favItem, object: nil)
        
        let notificationName = NSNotification.Name("NotificationIdf")
        NotificationCenter.default.addObserver(self, selector: #selector(FavoritesTableViewController.reloadTableView), name: notificationName, object: nil)
        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if self.favoriteMenuItems.count == 0 && self.favoriteDiningHalls.count == 0 {
            self.clearButton.title = ""
            self.clearButton.isEnabled = false
            
            self.navigationItem.rightBarButtonItem?.title = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else {
            self.clearButton.title = "Clear"
            self.clearButton.isEnabled = true
            
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        self.reloadTableView()
    }
    
    func reloadTableView() {
        self.favoriteDiningHalls = FavoritesManager.shared.favoriteLocationsStr
        self.favoriteMenuItems = FavoritesManager.shared.favoriteMenuItemsStr
        
        
        self.favoriteMenuItemsServedTodayStrs.removeAll()
        self.favoriteMenuItemsServedToday.removeAll()
        
        if self.favoriteMenuItems.count == 0 && self.favoriteDiningHalls.count == 0 {
            self.clearButton.title = ""
            self.clearButton.isEnabled = false
            
            self.navigationItem.rightBarButtonItem?.title = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else {
            self.clearButton.title = "Clear"
            self.clearButton.isEnabled = true
            
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        // seen menu items
        // keep track of menu items we've already seen
        var encountered = Set<String>()
        
        // go through every favorite
        // if served at a dining hall, add it to servedToday
        for item in favoriteMenuItems {
            for location in MenusProvider.shared.locations {
                if let meals = MenusProvider.shared.locationMenus[location.name] {
                    for meal in meals {
                        if let courses = meal.courses {
                            for course in courses {
                                for menuItem in course.menuItems {
                                    if menuItem.name == item {
                                        if !encountered.contains(item) {
                                            // append result
                                            self.favoriteMenuItemsServedToday.append(menuItem)
                                            self.favoriteMenuItemsServedTodayStrs.append(item)
                                            // add to set
                                            encountered.insert(item)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.tableView.reloadData()
        self.findAndSendNotifications()
    }

    func clear() {
        
        
        if self.favoriteDiningHalls.count != 0
            || self.favoriteMenuItems.count != 0 {
        
            let clearAlert = UIAlertController(title: "Clear", message: "Selected Favorites Will Be Removed", preferredStyle: UIAlertControllerStyle.alert)
            
            
            if self.favoriteDiningHalls.count != 0 {
                clearAlert.addAction(UIAlertAction(title: "Locations", style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.favoriteDiningHalls.removeAll()
                    let success = FavoritesManager.shared.removeAllFavoriteLocations()
                    if success {
                        self.reloadTableView()
                    }
                }))
            }
            
            if self.favoriteMenuItems.count != 0 {
                clearAlert.addAction(UIAlertAction(title: "Menu Items", style: .default, handler: { (action: UIAlertAction!) in
                    self.favoriteMenuItems.removeAll()
                    let success = FavoritesManager.shared.removeAllFavItems()
                    if success {
                        self.reloadTableView()
                    }
                }))
            }
            
            if self.favoriteMenuItems.count != 0 && self.favoriteDiningHalls.count != 0 {
                clearAlert.addAction(UIAlertAction(title: "All", style: .destructive, handler: { (action: UIAlertAction!) in
                    self.favoriteDiningHalls.removeAll()
                    self.favoriteMenuItems.removeAll()
                    FavoritesManager.shared.removeAll()
                    self.reloadTableView()
                }))
            }
            
            clearAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Cancel, do nothing")
            }))
            
            present(clearAlert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            if self.favoriteMenuItems.count == 0 && self.favoriteDiningHalls.count == 0 {
                return 1
            }
            else {
                return 0
            }
        }
        else if section == 1 {
            if favoriteDiningHalls.count != 0 {
                return favoriteDiningHalls.count
            }
            else {
                return 0
            }
        }
        else {
            if favoriteMenuItems.count != 0 {
                return favoriteMenuItems.count
            }
            else {
                return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            if self.favoriteDiningHalls.count != 0 {
                return "Locations"
            }
            else {
                return ""
            }
        }
        else if section == 2 {
            if self.favoriteMenuItems.count != 0 {
                return "Menu Items"
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50.0
        }
        else {
            return 55.0
        }
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selects location
        if indexPath.section == 1 {
            performSegue(withIdentifier: "FavToDiningHall", sender: self)
        }
        // selects menuitem
        else if indexPath.section == 2 {
            let cell = tableView.cellForRow(at: indexPath)
            if cell?.detailTextLabel?.text == "Served Today!" {
                performSegue(withIdentifier: "FavToItem", sender: self)
            }
        }
        // compile
        else {
            print("Selected a non-important row")
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoItems", for: indexPath)
            cell.textLabel?.text = "No Favorites Yet  🙃"// Add Some!"
            cell.textLabel?.textAlignment = .center
            cell.accessoryType = .none
            cell.isUserInteractionEnabled = false
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteLocation", for: indexPath)

            //if favoriteDiningHalls.count != 0 {
                cell.textLabel?.text = favoriteDiningHalls[indexPath.row]
                cell.detailTextLabel?.text = ""
            //}
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteItem", for: indexPath)

            cell.textLabel?.text = favoriteMenuItems[indexPath.row]
            
            if self.favoriteMenuItemsServedTodayStrs.contains(favoriteMenuItems[indexPath.row]) {
                cell.detailTextLabel?.text = "Served Today!"
                cell.isUserInteractionEnabled = true
                cell.accessoryType = .disclosureIndicator
                cell.backgroundColor = UIColor.white
            }
            else {
                cell.detailTextLabel?.text = "Not Served Today"
                cell.isUserInteractionEnabled = true
                cell.accessoryType = .none
                cell.backgroundColor = GlobalVariables.lightGrey
            }
            
            return cell
            
        }
}
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // deleting dining location
            if indexPath.section == 1 {
                self.favoriteDiningHalls.remove(at: indexPath.row)
                let title = tableView.cellForRow(at: indexPath)?.textLabel?.text!
                FavoritesManager.shared.removeLocation(location: title!)
            }
            // deleting item
            else if indexPath.section == 2 {
                self.favoriteMenuItems.remove(at: indexPath.row)
                let title = tableView.cellForRow(at: indexPath)?.textLabel?.text!
                FavoritesManager.shared.removeMenuItem(item: title!)
            }
            
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FavToDiningHall" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if indexPath.section == 1 {
                    if let SpecificTVC = segue.destination as? Specific_Dining_ViewController {
                        SpecificTVC.selectedDiningLocation = MenusProvider.shared.locations[MenusProvider.shared.locationDictionary[self.favoriteDiningHalls[indexPath.row]]!]
                        SpecificTVC.title = self.favoriteDiningHalls[indexPath.row]
                        SpecificTVC.selectedDiningName = self.favoriteDiningHalls[indexPath.row]
                    }
                }
            }
        }
        else if segue.identifier == "FavToItem" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if indexPath.section == 2 {
                    if let MenuItemTVC = segue.destination as? MenuItemTableViewController {
                        let item = self.favoriteMenuItems[indexPath.row]
                        let idx = self.favoriteMenuItemsServedTodayStrs.index(of: item)
                        MenuItemTVC.selectedMenuItem = self.favoriteMenuItemsServedToday[idx!]
                        MenuItemTVC.title = self.favoriteMenuItemsServedTodayStrs[idx!]
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Push Notifications from Favorites!
    func findAndSendNotifications() {
        print("Finding Potential Notifications")
        
        var foundItem = ""
        var foundItemLocation = ""
        var foundItemMeal = ""
        var didFindItem = false
        
        // go through every favorite
        // if served at a dining hall, add it to servedToday
        for item in favoriteMenuItems {
            if !didFindItem {
                for location in MenusProvider.shared.locations {
                    if let meals = MenusProvider.shared.locationMenus[location.name] {
                        if !didFindItem {
                            for meal in meals {
                                if let courses = meal.courses {
                                    if !didFindItem {
                                        for course in courses {
                                            if !didFindItem {
                                                for menuItem in course.menuItems {
                                                    if !didFindItem {
                                                        if menuItem.name == item {
                                                            foundItem = item
                                                            foundItemLocation = location.name
                                                            foundItemMeal = meal.type.rawValue
                                                            didFindItem = true
                                                            print("Found \(item)!!!")
                                                            break
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // if we did find an item to send a notification about, then configue
        // and send it!
        // will only send if application is in the background
        if didFindItem {
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Favorite Menu Item!", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "\(foundItemLocation) is serving \(foundItem) for \(foundItemMeal) today!", arguments: nil)
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = "MenuItem"

            // send notification in 5 seconds
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest.init(identifier: "MenuItem", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    

    
}
