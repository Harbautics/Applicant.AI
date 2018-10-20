//
//  MenuItemTableViewController.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/20/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit
import HealthKit

class MenuItemTableViewController: UITableViewController {

    // Properties
    var selectedMenuItem: MenuItem!
        
    var isFavorite = false
    
    var addedToHealthKit = false
    
    // FLICKER API CODE
    let api_key = "6e950b5a7b1cc149ec033b8c9e968657"
    let flickr_url = "https://api.flickr.com/services/rest/"
    let search_method = "flickr.photos.search"
    let format = "json"
    let json_callback = 1
    let privacy_level = 1
    
    // Outlets
    @IBOutlet weak var mainImg: UIImageView!
    
    
    // Actions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adding bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More Info", style: .plain, target: self, action: #selector(moreInfo))
        let font:UIFont = UIFont(name: "HelveticaNeue", size: 16.0)!
        let attributes:[String : Any] = [NSFontAttributeName: font];
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        
        // set the favorite!
        self.isFavorite = FavoritesManager.shared.isFavorite(item: self.selectedMenuItem.name)
        
        let favItem = NSNotification.Name("SavedFavItem")
        NotificationCenter.default.addObserver(self, selector: #selector(MenuItemTableViewController.updateFavorite), name: favItem, object: nil)
        
        
        // set the main Image from the given URL
        if self.selectedMenuItem.imageURL != nil {
            let imageURL = self.selectedMenuItem.imageURL
            if let checkedUrl = URL(string: imageURL!) {
                mainImg.contentMode = .scaleToFill
                downloadImage(url: checkedUrl)
            }
        }
        // GET the image from flickr
        else {
            getFlickrPhoto(self.selectedMenuItem.name)
        }
    }
    
    func updateFavorite() {
        self.isFavorite = FavoritesManager.shared.isFavorite(item: self.selectedMenuItem.name)
        self.tableView.reloadData()
    }
    
    // go to more info page
    func moreInfo() {
        performSegue(withIdentifier: "MoreInfo", sender: self)
    }

    // downloads an image from a given URL
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.mainImg.image = UIImage(data: data)
            }
        }
    }
    
    // gets the actual Image Data fro a URL
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    // gets a photo from Flickr's API
    func getFlickrPhoto(_ search_text: String) {
        //format the search text
        let escapedString = search_text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        // photos search, text search, 10 results, json format
        let search_request = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(self.api_key)&text=\(escapedString!)&per_page=10&format=json&nojsoncallback=1"

        let search_url = URL(string: search_request)!
        
        // get the first image
        self.fetch(url: search_url) { (json) in
            if let firstPhoto = json["photos"]["photo"][0].dictionary {
                if let id = firstPhoto["id"]?.string {
                    
                    // now get the size of the image
                    let size_request = "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=\(self.api_key)&photo_id=\(id)&format=json&nojsoncallback=1"
                    
                    let size_url = URL(string: size_request)!
                    
                    self.fetch(url: size_url, completionHandler: { (json2) in
                        if let photos = json2["sizes"]["size"].array {
                            if let photo = photos[5].dictionary {
                                if let source = photo["source"]?.string {
                                    if let checkedUrl = URL(string: source) {
                                        self.mainImg.contentMode = .scaleToFill
                                        self.downloadImage(url: checkedUrl)
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    // taken from MenusAPIManager, gets JSON from an API response
    func fetch(url: URL, completionHandler: @escaping ((JSON) -> Void)) {
        // get off the main queue to avoid blocking rendering of UI
        DispatchQueue.global(qos: .default).async {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if data != nil {
                        let json = JSON(data: data!)
                        completionHandler(json)
                    }
                }
            }
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 {
            return "Nutrition Information"
        }
        else {
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // trait cell
        if section == 0 {
            return 1
        }
        // add to favorites cell
        else if section == 1 {
            return 1
        }
        // add to health kit
        else if section == 2 {
            return 1
        }
        // nutrition cell
        else {
            return self.selectedMenuItem.nutritionInfoArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // traits
        if indexPath.section == 0 {
            if self.selectedMenuItem.traits.count == 0 {
                return 0.0
            }
            else {
                return 44.0
            }
        }
        // add to favorites
        else if indexPath.section == 1 {
            return 44.0
        }
        // add to health kit
        else if indexPath.section == 2 {
            return 44.0
        }
        // nutrition info not needed
        else {
            return 44.0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Trait Cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TraitSection", for: indexPath) as! TraitsTableViewCell
            
            var trait_str = ""
            
            if self.selectedMenuItem.traits.count != 0 {
                
                // set the list of traits
                let array = self.selectedMenuItem.traits
                for item in array {
                    trait_str += "\(item)"
                    if item != array[array.endIndex - 1] {
                        trait_str += ", "
                    }
                }
            }
            
            cell.traitsLabel.text = trait_str
            cell.traitsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
            cell.traitsLabel.textAlignment = .center
                        
            cell.isUserInteractionEnabled = false
            
            return cell
        }
        // add to favorites
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddFavorites", for: indexPath)
            if self.isFavorite {
                cell.textLabel?.text = "Remove From Favorites"
                cell.textLabel?.textColor = GlobalVariables.red
            }
            else {
                cell.textLabel?.text = "Add To Favorites"
                cell.textLabel?.textColor = GlobalVariables.green
            }
            cell.textLabel?.textAlignment = .center
            
            return cell
            
        }
        // add to HealthKit
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddHealthKit", for: indexPath)

            if !self.addedToHealthKit {
                cell.textLabel?.text = "Add To HealthKit"
                
            }
            else {
                cell.textLabel?.text = "Tap to Add Another Serving"
            }
            
            cell.textLabel?.textColor = GlobalVariables.orange
            cell.textLabel?.textAlignment = .center
            
            return cell
        }
        // nutrition information
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionInfo", for: indexPath)
            
            cell.textLabel?.text = self.selectedMenuItem.nutritionInfoArray[indexPath.row].name
            cell.detailTextLabel?.text = self.selectedMenuItem.nutritionInfoArray[indexPath.row].value
            
            cell.isUserInteractionEnabled = false
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selected Favorite
        if indexPath.section == 1 {
            self.toggleFavorite()
        }
        // selected Add to health kit!
        else if indexPath.section == 2 {
            if !self.addedToHealthKit {
                self.addedToHealthKit = true
            }
            self.tableView.reloadData()
        }
    }
    
    func toggleFavorite() {
        // change the UI
        // get the cell!
        let cell = tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 1))
        
        let desired_action = cell.textLabel?.text
        
        if desired_action == "Add To Favorites" {
            self.isFavorite = true
            self.tableView.reloadData()
            FavoritesManager.shared.addFavMenuItem(item: self.selectedMenuItem.name)
        }
        else {
            self.isFavorite = false
            self.tableView.reloadData()
            FavoritesManager.shared.removeMenuItem(item: self.selectedMenuItem.name)
        }
        
        // alter the favorite
        // do something with the favorites manager
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
        
        // segue to more info
        if segue.identifier == "MoreInfo" {
            if let MoreInfoTVC = segue.destination as? MoreInfoTableViewController {
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                
                let font:UIFont = UIFont(name: "HelveticaNeue", size: 17.0)!
                let attributes:[String : Any] = [NSFontAttributeName: font];
                
                backItem.setTitleTextAttributes(attributes, for: .normal)
                navigationItem.backBarButtonItem = backItem
                
                MoreInfoTVC.menuItem = self.selectedMenuItem.name
                MoreInfoTVC.title = "Info: \(self.selectedMenuItem.name)"
            }
            
        }
        
    }
 
}
