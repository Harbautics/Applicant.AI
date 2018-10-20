//
//  Specific_Dining_ViewController.swift
//  dining_app
//
//  Created by Jordan Wolff on 3/1/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit
import MapKit

extension UILabel {
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false) {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel) {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

class Specific_Dining_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedDiningLocation: DiningLocation!
    
    var tableView: UITableView = UITableView()
    
    var meals = [Meal]()
    
    var defaultDay = 0
    
    var selectedDiningName: String = ""
    
    var isFavorite = false
    
    var hours = [(eventTitle: String, hours: String)]()
    
    var capacity = -1
    var occupancy = -1
    
    var noMeals = false
    var noMealFilled = false
    var noneHaveMeals = true
    var noMealTextSet = false
    
    var isUpdatingData = false
    
    // Properties
    // get the day of the week
    let weekday = Date().dayNumberOfWeek()!
    var isFav = false
    
    // get today current date
    let date = Date()
    let calendar = Calendar.current
    
    // Days of the week for getting meals / changing meals
    var day1 = Date()
    var day2 = Date()
    var day3 = Date()
    var day4 = Date()
    var day5 = Date()
    var day6 = Date()
    var day7 = Date()
    
    var days = [Date]()
    
    // hidden rows?
    var tableHidden = false
    
    // activity indicator
    var indicator = UIActivityIndicatorView()
    
    
    // Constants
    let blue = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
    let red = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
    let reuseCellIdentifier = "mealCell"
    let reuseCellIdentifier2 = "FavoriteCell"
    let reuseCellIdentifier3 = "Capacity"
    let reuseCellIdentifier4 = "Hours"
    let reuseCellIdentifier5 = "Address"
    
    // Outlets
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!    
    
    
    // Calendar Images
    @IBOutlet weak var cal6: UIImageView!
    @IBOutlet weak var cal5: UIImageView!
    @IBOutlet weak var cal4: UIImageView!
    @IBOutlet weak var cal3: UIImageView!
    @IBOutlet weak var cal2: UIImageView!
    @IBOutlet weak var cal1: UIImageView!
    @IBOutlet weak var cal0: UIImageView!
    @IBOutlet weak var favIcon: UIImageView!
    
    
    // Calendar Numbers
    @IBOutlet weak var calNum6: UIButton!
    @IBOutlet weak var calNum5: UIButton!
    @IBOutlet weak var calNum4: UIButton!
    @IBOutlet weak var calNum3: UIButton!
    @IBOutlet weak var calNum2: UIButton!
    @IBOutlet weak var calNum1: UIButton!
    @IBOutlet weak var calNum0: UIButton!
    
    
    
    // Actions


    // Pressing Calendar Numbers
    @IBAction func chooseDay6(_ sender: UIButton) {
        // disable touch to prevent duplicate touches
        self.disableTouch()
        
        // set chosen date background
        setCalBackground(Image: 6)
        
        // hide the table view, update
        self.tableView.isHidden = true;
        self.tableHidden = true
        self.tableView.reloadData()
        
        // start activity indicator
        self.activityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        // update the label
        self.dateLabel.text = ""
        // update the meals
        self.updateMeals(Num: 6)
        
        // disable touch on this button
        calNum6.isEnabled = false
        
        // enable touch on all other buttons
        calNum0.isEnabled = true
        calNum1.isEnabled = true
        calNum2.isEnabled = true
        calNum3.isEnabled = true
        calNum4.isEnabled = true
        calNum5.isEnabled = true
        
        // set default colot
        self.setDefaultColor(def: self.defaultDay, sender: 6)
    }
    
    @IBAction func chooseDay5(_ sender: UIButton) {
        // disable touch to prevent duplicate touches
        self.disableTouch()

        
        setCalBackground(Image: 5)
        // hide the table view, update
        self.tableView.isHidden = true;
        self.tableHidden = true
        self.tableView.reloadData()
        // start activity indicator
        self.activityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        // update the label
        self.dateLabel.text = ""
        self.updateMeals(Num: 5)
        
        // disable touch on this button
        calNum5.isEnabled = false
        
        // enable touch on all other buttons
        calNum0.isEnabled = true
        calNum1.isEnabled = true
        calNum2.isEnabled = true
        calNum3.isEnabled = true
        calNum4.isEnabled = true
        calNum6.isEnabled = true
        
        // set default colot
        self.setDefaultColor(def: self.defaultDay, sender: 5)
    }
    @IBAction func chooseDay4(_ sender: UIButton) {
        // disable touch to prevent duplicate touches
        self.disableTouch()

        setCalBackground(Image: 4)
        // hide the table view, update
        self.tableView.isHidden = true;
        self.tableHidden = true
        self.tableView.reloadData()
        // start activity indicator
        self.activityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        // update the label
        self.dateLabel.text = ""
        self.updateMeals(Num: 4)
        
        // disable touch on this button
        calNum4.isEnabled = false
        
        // enable touch on all other buttons
        calNum0.isEnabled = true
        calNum1.isEnabled = true
        calNum2.isEnabled = true
        calNum3.isEnabled = true
        calNum5.isEnabled = true
        calNum6.isEnabled = true
        
        // set default colot
        self.setDefaultColor(def: self.defaultDay, sender: 4)
    }
    @IBAction func chooseDay3(_ sender: UIButton) {
        // disable touch to prevent duplicate touches
        self.disableTouch()

        setCalBackground(Image: 3)
        // hide the table view, update
        self.tableView.isHidden = true;
        self.tableHidden = true
        self.tableView.reloadData()
        // start activity indicator
        self.activityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        // update the label
        self.dateLabel.text = ""
        self.updateMeals(Num: 3)
        
        // disable touch on this button
        calNum3.isEnabled = false
        
        // enable touch on all other buttons
        calNum0.isEnabled = true
        calNum1.isEnabled = true
        calNum2.isEnabled = true
        calNum4.isEnabled = true
        calNum5.isEnabled = true
        calNum6.isEnabled = true
        
        // set default colot
        self.setDefaultColor(def: self.defaultDay, sender: 3)
    }
    @IBAction func chooseDay2(_ sender: UIButton) {
        // disable touch to prevent duplicate touches
        self.disableTouch()

        setCalBackground(Image: 2)
        // hide the table view, update
        self.tableView.isHidden = true;
        self.tableHidden = true
        self.tableView.reloadData()
        // start activity indicator
        self.activityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        // set label null
        self.dateLabel.text = ""
        self.updateMeals(Num: 2)
        
        // disable touch on this button
        calNum2.isEnabled = false
        
        // enable touch on all other buttons
        calNum0.isEnabled = true
        calNum1.isEnabled = true
        calNum3.isEnabled = true
        calNum4.isEnabled = true
        calNum5.isEnabled = true
        calNum6.isEnabled = true
        
        // set default colot
        self.setDefaultColor(def: self.defaultDay, sender: 2)
    }
    @IBAction func chooseDay1(_ sender: UIButton) {
        // disable touch to prevent duplicate touches
        self.disableTouch()

        setCalBackground(Image: 1)
        // hide the table view, update
        self.tableView.isHidden = true;
        self.tableHidden = true
        self.tableView.reloadData()
        // start activity indicator
        self.activityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        // update the label
        self.dateLabel.text = ""
        self.updateMeals(Num: 1)
        
        // disable touch on this button
        calNum1.isEnabled = false
        
        // enable touch on all other buttons
        calNum0.isEnabled = true
        calNum2.isEnabled = true
        calNum3.isEnabled = true
        calNum4.isEnabled = true
        calNum5.isEnabled = true
        calNum6.isEnabled = true
        
        // set default colot
        self.setDefaultColor(def: self.defaultDay, sender: 1)
    }
    @IBAction func chooseDay0(_ sender: UIButton) {
        // disable touch to prevent duplicate touches
        self.disableTouch()

        setCalBackground(Image: 0)
        // hide the table view, update
        self.tableView.isHidden = true;
        self.tableHidden = true
        self.tableView.reloadData()
        // start activity indicator
        self.activityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        // update the label
        self.dateLabel.text = ""
        self.updateMeals(Num: 0)
        
        // disable touch on this button
        calNum0.isEnabled = false
        
        // enable touch on all other buttons
        calNum1.isEnabled = true
        calNum2.isEnabled = true
        calNum3.isEnabled = true
        calNum4.isEnabled = true
        calNum5.isEnabled = true
        calNum6.isEnabled = true
        
        // set default colot
        self.setDefaultColor(def: self.defaultDay, sender: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = self.title
        if (title?.contains("Dining Hall"))! {
            self.title = title?.replacingOccurrences(of: "Dining Hall", with: " ")
        }
        
        if self.selectedDiningLocation.capacity != nil {
            self.capacity = self.selectedDiningLocation.capacity!
        }
        
        let favLocation = NSNotification.Name("SavedFavLocation")
        NotificationCenter.default.addObserver(self, selector: #selector(Specific_Dining_ViewController.updateFavorite), name: favLocation, object: nil)
        
        // set isFavorite
        self.isFavorite = FavoritesManager.shared.isFavorite(location: self.selectedDiningLocation.name)
        
        // Initializing tableView
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier2)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier3)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier4)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier5)
        self.view.addSubview(self.tableView)
        // set the frame parameters and location on view
        let frame = CGRect(x: 0, y: 332, width: 376, height: 288)
        tableView.frame = frame
        
        self.mainImg.image = UIImage(named: self.selectedDiningName)
        
        
        // get data from the Menus Provider shared class
        if let meals = MenusProvider.shared.locationMenus[self.selectedDiningName] {
            self.meals = meals
            
            // checking if no meals
            if self.meals.count == 0 {
                self.noMeals = true
            }
            
            print("Successfully loaded meals from MenusProvider")
            self.continueInit()
            self.updateDateLabel(Num: self.weekday - 1)
            
            // checking if there are no courses i.e. no actual meals

            for item in self.meals {
                if item.courses != nil {
                    self.noneHaveMeals = false
                }
            }
            
        }
        // otherwise get the data from the API
        else {
            
            // set updating data variable
            self.isUpdatingData = true
            
            // update the label
            self.dateLabel.text = ""
            
            // start activity indicator
            self.activityIndicator()
            self.indicator.startAnimating()
            self.indicator.backgroundColor = UIColor.black
            
            MenusAPIManager.getMeals(for: self.selectedDiningLocation, completionHandler: { (mealToLoad) in
                self.meals = mealToLoad
                
                // checking if no meals
//                if self.meals.count == 0 {
//                    self.noMeals = true
//                }
                
                // checking if there are no courses i.e. no actual meals
                for item in self.meals {
                    if item.courses != nil {
                        self.noneHaveMeals = false
                    }
                }
                
                self.tableView.reloadData()
                self.continueInit()
                
                // stop activity indicator
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                
                
                self.updateDateLabel(Num: self.weekday - 1)
            })
        }
        
        
        
        // get hours
        MenusAPIManager.getHours(for: self.selectedDiningLocation, on: Date()) { (results: [(eventTitle: String, hours: String)]) in
            
            var unique_hours = [(eventTitle: String, hours: String)]()
            
            var encountered = Set<String>()
            
            unique_hours.append(results[0])
            encountered.insert(results[0].eventTitle)
            
            for result in results {
                if !encountered.contains(result.eventTitle) {
                    unique_hours.append(result)
                    encountered.insert(result.eventTitle)
                }
            }
            
            self.hours = unique_hours
            
            self.tableView.reloadData()
        }
        
        // get occupancy
        MenusAPIManager.getCurrentOccupancy(for: self.selectedDiningLocation) { (occupancy) in
            if occupancy != nil {
                self.occupancy = occupancy!
                self.tableView.reloadData()
            }
        }
                
    }
    
    func updateFavorite() {
        // set isFavorite
        self.isFavorite = FavoritesManager.shared.isFavorite(location: self.selectedDiningLocation.name)
        self.tableView.reloadData()
    }
    
    func continueInit() {
        
        // undo updating data
        self.isUpdatingData = false
        
        // reorder and remove non-wanted meals
        // should only have Breakfast, Lunch, Dinner
        
        var index = 0
        var meals = self.meals
        for meal in meals {
            let type = meal.type.rawValue
            if type == "Lunch Transition" || type == "Dinner Transition" || type == "Other" {
                meals.remove(at: index)
                index -= 1
            }
            else if meal.courses == nil {
                meals.remove(at: index)
                index -= 1
            }
            index += 1
        }
        
        self.meals = meals
        
        // sort
        self.meals.sort { (Meal1, Meal2) -> Bool in
            if Meal1.type.rawValue == "Breakfast" && Meal2.type.rawValue == "Lunch" {
                return true
            }
            else if Meal1.type.rawValue == "Breakfast" && Meal2.type.rawValue == "Dinner" {
                return true
            }
            else if Meal1.type.rawValue == "Lunch" && Meal2.type.rawValue == "Dinner" {
                return true
            }
            else {
                return false
            }
        }
        
        // set title
        self.initTitleColors()
        
        // set button lables
        self.initButtonsLabelsAndBackgrounds()
        self.tableView.reloadData()
        
        // initializing days of the week
        self.days.append(self.day1);
        self.days.append(self.day2);
        self.days.append(self.day3);
        self.days.append(self.day4);
        self.days.append(self.day5);
        self.days.append(self.day6);
        self.days.append(self.day7);
    }
    
    // configure the activity indicator
    func activityIndicator() {
        let frame = CGRect(x: 0, y: 140, width: 40, height: 40)
        self.indicator = UIActivityIndicatorView(frame: frame)
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    // disabling touching while loading
    func disableTouch() {
        self.view.isUserInteractionEnabled = false
        
    }
    
    func enableTouch() {
        self.view.isUserInteractionEnabled = true
    }
    
    func setDefaultColor(def: Int, sender: Int) {
        switch def {
        case 0:
            if def != sender {
                calNum0.setTitleColor(GlobalVariables.blue, for: .normal)
            }
            break
        case 1:
            if def != sender {
                calNum1.setTitleColor(GlobalVariables.blue, for: .normal)
            }
            break
        case 2:
            if def != sender {
                calNum2.setTitleColor(GlobalVariables.blue, for: .normal)
            }
            break
        case 3:
            if def != sender {
                calNum3.setTitleColor(GlobalVariables.blue, for: .normal)
            }
            break
        case 4:
            if def != sender {
                calNum4.setTitleColor(GlobalVariables.blue, for: .normal)
            }
            break
        case 5:
            if def != sender {
                calNum5.setTitleColor(GlobalVariables.blue, for: .normal)
            }
            break
        case 6:
            if def != sender {
                calNum6.setTitleColor(GlobalVariables.blue, for: .normal)
            }
            break
        default:
            print("Error")
            break
        }
    }
    
    
    func initTitleColors() {
        calNum0.setTitleColor(GlobalVariables.grey, for: .normal)
        calNum1.setTitleColor(UIColor.black, for: .normal)
        calNum2.setTitleColor(UIColor.black, for: .normal)
        calNum3.setTitleColor(UIColor.black, for: .normal)
        calNum4.setTitleColor(UIColor.black, for: .normal)
        calNum5.setTitleColor(UIColor.black, for: .normal)
        calNum6.setTitleColor(GlobalVariables.grey, for: .normal)
    }
    
    func initButtonsLabelsAndBackgrounds() {
        
        // current day
        let components = self.calendar.dateComponents([.year, .month, .day], from: self.date)
        let day = components.day
        
        // days behind
        var oneDayAgo = 0; var twoDaysAgo = 0; var threeDaysAgo = 0;
        var fourDaysAgo = 0; var fiveDaysAgo = 0; var sixDaysAgo = 0;
        
        // days ahead
        var oneDayAhead = 0; var twoDaysAhead = 0; var threeDaysAhead = 0;
        var fourDaysAhead = 0; var fiveDaysAhead = 0; var sixDaysAhead = 0;
        
        // setting days behind
        if let oneday = self.calendar.date(byAdding: .day, value: -1, to: Date()) {
            let oneDayAgoComponents = self.calendar.dateComponents([.year, .month, .day], from: oneday)
            oneDayAgo = oneDayAgoComponents.day!
        }
        
        if let twoday = self.calendar.date(byAdding: .day, value: -2, to: Date()) {
            let twoDayAgoComponents = self.calendar.dateComponents([.year, .month, .day], from: twoday)
            twoDaysAgo = twoDayAgoComponents.day!
        }
        
        if let threeday = self.calendar.date(byAdding: .day, value: -3, to: Date()) {
            let threeDayAgoComponents = self.calendar.dateComponents([.year, .month, .day], from: threeday)
            threeDaysAgo = threeDayAgoComponents.day!
        }
        
        if let fourday = self.calendar.date(byAdding: .day, value: -4, to: Date()) {
            let fourDayAgoComponents = self.calendar.dateComponents([.year, .month, .day], from: fourday)
            fourDaysAgo = fourDayAgoComponents.day!
        }
        

        if let fiveday = self.calendar.date(byAdding: .day, value: -5, to: Date()) {
            let fiveDayAgoComponents = self.calendar.dateComponents([.year, .month, .day], from: fiveday)
            fiveDaysAgo = fiveDayAgoComponents.day!
        }
        
        if let sixday = self.calendar.date(byAdding: .day, value: -6, to: Date()) {
            let sixDayAgoComponents = self.calendar.dateComponents([.year, .month, .day], from: sixday)
            sixDaysAgo = sixDayAgoComponents.day!
        }

        // setting days ahead
        if let onedayA = self.calendar.date(byAdding: .day, value: +1, to: Date()) {
            let oneDayAComponents = self.calendar.dateComponents([.year, .month, .day], from: onedayA)
            oneDayAhead = oneDayAComponents.day!
        }
        
        if let twodayA = self.calendar.date(byAdding: .day, value: +2, to: Date()) {
            let twoDayAComponents = self.calendar.dateComponents([.year, .month, .day], from: twodayA)
            twoDaysAhead = twoDayAComponents.day!
        }
        
        if let threedayA = self.calendar.date(byAdding: .day, value: +3, to: Date()) {
            let threeDayAComponents = self.calendar.dateComponents([.year, .month, .day], from: threedayA)
            threeDaysAhead = threeDayAComponents.day!
        }
        
        if let fourdayA = self.calendar.date(byAdding: .day, value: +4, to: Date()) {
            let fourDayAComponents = self.calendar.dateComponents([.year, .month, .day], from: fourdayA)
            fourDaysAhead = fourDayAComponents.day!
        }
        
        
        if let fivedayA = self.calendar.date(byAdding: .day, value: +5, to: Date()) {
            let fiveDayAComponents = self.calendar.dateComponents([.year, .month, .day], from: fivedayA)
            fiveDaysAhead = fiveDayAComponents.day!
        }
        
        if let sixdayA = self.calendar.date(byAdding: .day, value: +6, to: Date()) {
            let sixDayAComponents = self.calendar.dateComponents([.year, .month, .day], from: sixdayA)
            sixDaysAhead = sixDayAComponents.day!
        }

        // Formatting buttons!
        
        // make the day of the week button highlighted
        // Sunday: 1, Monday: 2, Tuesday: 3, Wednesday: 4, Thursday: 5, Friday: 6, Saturday: 7
        // and set the dates to be the current weekdays (numbers)
        if weekday == 1 {
            cal0.image = UIImage(named: "calBackgroundBlue")
            calNum0.isEnabled = false
            calNum0.setTitleColor(UIColor.white, for: .normal)
            calNum0.setTitle("\(day!)", for: .normal)
            calNum1.setTitle("\(oneDayAhead)", for: .normal)
            calNum2.setTitle("\(twoDaysAhead)", for: .normal)
            calNum3.setTitle("\(threeDaysAhead)", for: .normal)
            calNum4.setTitle("\(fourDaysAhead)", for: .normal)
            calNum5.setTitle("\(fiveDaysAhead)", for: .normal)
            calNum6.setTitle("\(sixDaysAhead)", for: .normal)
            // set the days of the week
            self.setDaysOfWeek(Day: 1)
            
            defaultDay = 0
            
        }
        else if weekday == 2 {
            cal1.image = UIImage(named: "calBackgroundBlue")
            calNum1.isEnabled = false
            calNum1.setTitleColor(UIColor.white, for: .normal)
            calNum0.setTitle("\(oneDayAgo)", for: .normal)
            calNum1.setTitle("\(day!)", for: .normal)
            calNum2.setTitle("\(oneDayAhead)", for: .normal)
            calNum3.setTitle("\(twoDaysAhead)", for: .normal)
            calNum4.setTitle("\(threeDaysAhead)", for: .normal)
            calNum5.setTitle("\(fourDaysAhead)", for: .normal)
            calNum6.setTitle("\(fiveDaysAhead)", for: .normal)
            // set the days of the week
            self.setDaysOfWeek(Day: 2)
            
            defaultDay = 1
        }
        else if weekday == 3 {
            cal2.image = UIImage(named: "calBackgroundBlue")
            calNum2.isEnabled = false
            calNum2.setTitleColor(UIColor.white, for: .normal)
            calNum0.setTitle("\(twoDaysAgo)", for: .normal)
            calNum1.setTitle("\(oneDayAgo)", for: .normal)
            calNum2.setTitle("\(day!)", for: .normal)
            calNum3.setTitle("\(oneDayAhead)", for: .normal)
            calNum4.setTitle("\(twoDaysAhead)", for: .normal)
            calNum5.setTitle("\(threeDaysAhead)", for: .normal)
            calNum6.setTitle("\(fourDaysAhead)", for: .normal)
            // set the days of the week
            self.setDaysOfWeek(Day: 3)
            
            defaultDay = 2
        }
        else if weekday == 4 {
            cal3.image = UIImage(named: "calBackgroundBlue")
            calNum3.isEnabled = false
            calNum3.setTitleColor(UIColor.white, for: .normal)
            calNum0.setTitle("\(threeDaysAgo)", for: .normal)
            calNum1.setTitle("\(twoDaysAgo)", for: .normal)
            calNum2.setTitle("\(oneDayAgo)", for: .normal)
            calNum3.setTitle("\(day!)", for: .normal)
            calNum4.setTitle("\(oneDayAhead)", for: .normal)
            calNum5.setTitle("\(twoDaysAhead)", for: .normal)
            calNum6.setTitle("\(threeDaysAhead)", for: .normal)
            // set the days of the week
            self.setDaysOfWeek(Day: 4)
            
            defaultDay = 3
        }
        else if weekday == 5 {
            cal4.image = UIImage(named: "calBackgroundBlue")
            calNum4.isEnabled = false
            calNum4.setTitleColor(UIColor.white, for: .normal)
            calNum0.setTitle("\(fourDaysAgo)", for: .normal)
            calNum1.setTitle("\(threeDaysAgo)", for: .normal)
            calNum2.setTitle("\(twoDaysAgo)", for: .normal)
            calNum3.setTitle("\(oneDayAgo)", for: .normal)
            calNum4.setTitle("\(day!)", for: .normal)
            calNum5.setTitle("\(oneDayAhead)", for: .normal)
            calNum6.setTitle("\(twoDaysAhead)", for: .normal)
            // set the days of the week
            self.setDaysOfWeek(Day: 5)
            
            defaultDay = 4
        }
        else if weekday == 6 {
            cal5.image = UIImage(named: "calBackgroundBlue")
            calNum5.isEnabled = false
            calNum5.setTitleColor(UIColor.white, for: .normal)
            calNum0.setTitle("\(fiveDaysAgo)", for: .normal)
            calNum1.setTitle("\(fourDaysAgo)", for: .normal)
            calNum2.setTitle("\(threeDaysAgo)", for: .normal)
            calNum3.setTitle("\(twoDaysAgo)", for: .normal)
            calNum4.setTitle("\(oneDayAgo)", for: .normal)
            calNum5.setTitle("\(day!)", for: .normal)
            calNum6.setTitle("\(oneDayAhead)", for: .normal)
            // set the days of the week
            self.setDaysOfWeek(Day: 6)
            
            defaultDay = 5
        }
        else if weekday == 7 {
            cal6.image = UIImage(named: "calBackgroundBlue")
            calNum6.isEnabled = false
            calNum6.setTitleColor(UIColor.white, for: .normal)
            calNum0.setTitle("\(sixDaysAgo)", for: .normal)
            calNum1.setTitle("\(fiveDaysAgo)", for: .normal)
            calNum2.setTitle("\(fourDaysAgo)", for: .normal)
            calNum3.setTitle("\(threeDaysAgo)", for: .normal)
            calNum4.setTitle("\(twoDaysAgo)", for: .normal)
            calNum5.setTitle("\(oneDayAgo)", for: .normal)
            calNum6.setTitle("\(day!)", for: .normal)
            // set the days of the week
            self.setDaysOfWeek(Day: 7)
            
            defaultDay = 6
        }
    }
    
    func setDaysOfWeek(Day: Int) {
        
        if Day == 1 {
            self.day1 = self.calendar.date(byAdding: .day, value: +0, to: Date())!
            self.day2 = self.calendar.date(byAdding: .day, value: +1, to: Date())!
            self.day3 = self.calendar.date(byAdding: .day, value: +2, to: Date())!
            self.day4 = self.calendar.date(byAdding: .day, value: +3, to: Date())!
            self.day5 = self.calendar.date(byAdding: .day, value: +4, to: Date())!
            self.day6 = self.calendar.date(byAdding: .day, value: +5, to: Date())!
            self.day7 = self.calendar.date(byAdding: .day, value: +6, to: Date())!
        }
        else if Day == 2 {
            self.day1 = self.calendar.date(byAdding: .day, value: -1, to: Date())!
            self.day2 = self.calendar.date(byAdding: .day, value: +0, to: Date())!
            self.day3 = self.calendar.date(byAdding: .day, value: +1, to: Date())!
            self.day4 = self.calendar.date(byAdding: .day, value: +2, to: Date())!
            self.day5 = self.calendar.date(byAdding: .day, value: +3, to: Date())!
            self.day6 = self.calendar.date(byAdding: .day, value: +4, to: Date())!
            self.day7 = self.calendar.date(byAdding: .day, value: +5, to: Date())!
        }
        else if Day == 3 {
            self.day1 = self.calendar.date(byAdding: .day, value: -2, to: Date())!
            self.day2 = self.calendar.date(byAdding: .day, value: -1, to: Date())!
            self.day3 = self.calendar.date(byAdding: .day, value: +0, to: Date())!
            self.day4 = self.calendar.date(byAdding: .day, value: +1, to: Date())!
            self.day5 = self.calendar.date(byAdding: .day, value: +2, to: Date())!
            self.day6 = self.calendar.date(byAdding: .day, value: +3, to: Date())!
            self.day7 = self.calendar.date(byAdding: .day, value: +4, to: Date())!
        }
        else if Day == 4 {
            self.day1 = self.calendar.date(byAdding: .day, value: -3, to: Date())!
            self.day2 = self.calendar.date(byAdding: .day, value: -2, to: Date())!
            self.day3 = self.calendar.date(byAdding: .day, value: -1, to: Date())!
            self.day4 = self.calendar.date(byAdding: .day, value: +0, to: Date())!
            self.day5 = self.calendar.date(byAdding: .day, value: +1, to: Date())!
            self.day6 = self.calendar.date(byAdding: .day, value: +2, to: Date())!
            self.day7 = self.calendar.date(byAdding: .day, value: +3, to: Date())!
        }
        else if Day == 5 {
            self.day1 = self.calendar.date(byAdding: .day, value: -4, to: Date())!
            self.day2 = self.calendar.date(byAdding: .day, value: -3, to: Date())!
            self.day3 = self.calendar.date(byAdding: .day, value: -2, to: Date())!
            self.day4 = self.calendar.date(byAdding: .day, value: -1, to: Date())!
            self.day5 = self.calendar.date(byAdding: .day, value: +0, to: Date())!
            self.day6 = self.calendar.date(byAdding: .day, value: +1, to: Date())!
            self.day7 = self.calendar.date(byAdding: .day, value: +2, to: Date())!
        }
        else if Day == 6 {
            self.day1 = self.calendar.date(byAdding: .day, value: -5, to: Date())!
            self.day2 = self.calendar.date(byAdding: .day, value: -4, to: Date())!
            self.day3 = self.calendar.date(byAdding: .day, value: -3, to: Date())!
            self.day4 = self.calendar.date(byAdding: .day, value: -2, to: Date())!
            self.day5 = self.calendar.date(byAdding: .day, value: -1, to: Date())!
            self.day6 = self.calendar.date(byAdding: .day, value: +0, to: Date())!
            self.day7 = self.calendar.date(byAdding: .day, value: +1, to: Date())!
        }
        else if Day == 7 {
            self.day1 = self.calendar.date(byAdding: .day, value: -6, to: Date())!
            self.day2 = self.calendar.date(byAdding: .day, value: -5, to: Date())!
            self.day3 = self.calendar.date(byAdding: .day, value: -4, to: Date())!
            self.day4 = self.calendar.date(byAdding: .day, value: -3, to: Date())!
            self.day5 = self.calendar.date(byAdding: .day, value: -2, to: Date())!
            self.day6 = self.calendar.date(byAdding: .day, value: -1, to: Date())!
            self.day7 = self.calendar.date(byAdding: .day, value: +0, to: Date())!
        }
        else {
            print("Error in setting day, unknown value found")
        }
    }
    
    func updateDateLabel(Num: Int) {
        let date = self.days[Num]
        let components = self.calendar.dateComponents([.year, .month, .day], from: date)
        
        let day = components.day
        let month = components.month
        let year = components.year
        let weekday = date.dayNumberOfWeek()
        
        
        var date_str = ""
        
        // format day of week
        switch weekday! {
        case 1:
            date_str += "Sunday  "
            break
        case 2:
            date_str += "Monday  "
            break
        case 3:
            date_str += "Tuesday  "
            break
        case 4:
            date_str += "Wednesday  "
            break
        case 5:
            date_str += "Thursday  "
            break
        case 6:
            date_str += "Friday  "
            break
        case 7:
            date_str += "Saturday  "
            break
        default:
            date_str += "Unknown Day  "
            break
        }
        
        // format month
        switch month! {
        case 1:
            date_str += "January "
            break
        case 2:
            date_str += "Febrauary "
            break
        case 3:
            date_str += "March "
            break
        case 4:
            date_str += "April "
            break
        case 5:
            date_str += "May "
            break
        case 6:
            date_str += "June "
            break
        case 7:
            date_str += "July "
            break
        case 8:
            date_str += "August "
            break
        case 9:
            date_str += "September "
            break
        case 10:
            date_str += "October "
            break
        case 11:
            date_str += "November "
            break
        case 12:
            date_str += "December "
            break
        default:
            date_str += "Unknown Month"
            break
        }
        
        date_str += "\(day!), "
        date_str += "\(year!)"
        
        self.dateLabel.text = date_str
    }
    
    func setCalBackground(Image: Int) {
        cal6.image = nil
        cal5.image = nil
        cal4.image = nil
        cal3.image = nil
        cal2.image = nil
        cal1.image = nil
        cal0.image = nil
        
        calNum0.setTitleColor(GlobalVariables.grey, for: .normal)
        calNum1.setTitleColor(UIColor.black, for: .normal)
        calNum2.setTitleColor(UIColor.black, for: .normal)
        calNum3.setTitleColor(UIColor.black, for: .normal)
        calNum4.setTitleColor(UIColor.black, for: .normal)
        calNum5.setTitleColor(UIColor.black, for: .normal)
        calNum6.setTitleColor(GlobalVariables.grey, for: .normal)
        
        var imageName = "calBackgroundBlue"
        
        if (self.days[Image].dayNumberOfWeek()! != self.date.dayNumberOfWeek()!) {
            imageName = "calBackgroundBlack"
        }
        
        if Image == 0 {
            cal0.image = UIImage(named: imageName)
            calNum0.setTitleColor(UIColor.white, for: .normal)
        }
        else if Image == 1 {
            cal1.image = UIImage(named: imageName)
            calNum1.setTitleColor(UIColor.white, for: .normal)
        }
        else if Image == 2 {
            cal2.image = UIImage(named: imageName)
            calNum2.setTitleColor(UIColor.white, for: .normal)
        }
        else if Image == 3 {
            cal3.image = UIImage(named: imageName)
            calNum3.setTitleColor(UIColor.white, for: .normal)
        }
        else if Image == 4 {
            cal4.image = UIImage(named: imageName)
            calNum4.setTitleColor(UIColor.white, for: .normal)
        }
        else if Image == 5 {
            cal5.image = UIImage(named: imageName)
            calNum5.setTitleColor(UIColor.white, for: .normal)
        }
        else if Image == 6 {
            cal6.image = UIImage(named: imageName)
            calNum6.setTitleColor(UIColor.white, for: .normal)
        }
        
    }
    
    // updates the meals, num is the button selected
    func updateMeals(Num: Int) {
        
        // check to see if we've preloaded the meals
        // if so, just return that, don't make an API call
        let newDate = self.days[Num]
        
        // if current day of week selected
        if newDate.dayNumberOfWeek()! == self.date.dayNumberOfWeek()! {
            
            // get data from the Menus Provider shared class
            if let meals = MenusProvider.shared.locationMenus[self.selectedDiningName] {
                self.meals = meals
                print("Successfully loaded meals from MenusProvider")
                self.filterMeals()
                self.finishUpdate(Num: Num)
                return;
            }
                // otherwise get the data from the API
            else {
                MenusAPIManager.getMeals(for: self.selectedDiningLocation, completionHandler: { (mealToLoad) in
                    self.meals = mealToLoad
                    self.filterMeals()
                    self.tableView.reloadData()
                    self.finishUpdate(Num: Num)
                    return;
                })
            }
        }
        // non current day selected
        else {
            // no pre-loaded meals, make API call
            MenusAPIManager.getMeals(for: self.selectedDiningLocation, on: self.days[Num]) { (mealsToLoad) in
                self.meals = mealsToLoad
                self.filterMeals()
                self.finishUpdate(Num: Num)
                return;
            }
        }
    }
    
    func filterMeals() {
        var index = 0
        var meals = self.meals
        for meal in meals {
            let type = meal.type.rawValue
            if type == "Lunch Transition" || type == "Dinner Transition" || type == "Other" {
                meals.remove(at: index)
                index -= 1
            }
            else if meal.courses == nil {
                meals.remove(at: index)
                index -= 1
            }
            index += 1
        }
        
        self.meals = meals
        
        // sort
        self.meals.sort { (Meal1, Meal2) -> Bool in
            if Meal1.type.rawValue == "Breakfast" && Meal2.type.rawValue == "Lunch" {
                return true
            }
            else if Meal1.type.rawValue == "Breakfast" && Meal2.type.rawValue == "Dinner" {
                return true
            }
            else if Meal1.type.rawValue == "Lunch" && Meal2.type.rawValue == "Dinner" {
                return true
            }
            else {
                return false
            }
        }
        
        print(self.meals)
    }
    
    // abstracts duplicate code for updateMeals
    func finishUpdate(Num: Int) {
        // unhide the table
        self.tableHidden = false
        self.tableView.isHidden = false
        // stop activity indicator
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
        
        self.updateDateLabel(Num: Num)
        // reload table
        self.tableView.reloadData()
        // re-enable touch
        self.enableTouch()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // meals
        if section == 0 {
            if self.isUpdatingData {
                return 0
            }
            else {
                var numHaveMeals = 0
                if meals.count != 0 {
                    for meal in self.meals {
                        if meal.courses != nil {
                            numHaveMeals += 1
                        }
                    }
                }
                
                if numHaveMeals == 0 {
                    self.noMeals = true
                    return 1
                }
                else {
                    self.noMeals = false
                    return numHaveMeals
                }
            }
        }
        // favorite
        else if section == 1 {
            return 1
        }
            // address
        else if section == 2 {
            return 1
        }
        // capacity
        else if section == 3 {
            if self.capacity != -1 {
                return 1
            }
            else {
                return 0
            }
        }
        // hours
        else if section == 4 {
            if self.hours.count != 0 {
                return self.hours.count
            }
            else {
                return 0
            }
        }
        else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // meals
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath)
            
            if self.noMeals {
                cell.textLabel?.text = "No Meals Served Today"
                cell.textLabel?.textAlignment = .center
                cell.accessoryType = .none
            }
            else {
                let text = "\(meals[indexPath.row].type)"
                cell.textLabel?.text = text
                cell.accessoryType = .disclosureIndicator

            }
            

            // if table is hidden
            if (self.tableHidden) {
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = ""
                // actually hide the cell
                cell.isHidden = true
            }
            
            if (!self.tableHidden) {
                cell.isUserInteractionEnabled = true;
                cell.selectionStyle = UITableViewCellSelectionStyle.default
                cell.isHidden = false
            }
            
            // set separator inset to 0
            //let edgeInset = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 0.0)
            //cell.separatorInset = edgeInset
            // change font and fontsize
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
            
            
            return cell
        }
        // favorite
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier2, for: indexPath)
            
            if !self.isUpdatingData {
                if self.isFavorite {
                    cell.textLabel?.text = "Remove From Favorites"
                    cell.textLabel?.textColor = GlobalVariables.red
                }
                else {
                    cell.textLabel?.text = "Add To Favorites"
                    cell.textLabel?.textColor = GlobalVariables.green
                }
            }
            else {
                cell.textLabel?.text = ""
            }
            
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)
            cell.textLabel?.textAlignment = .center
            
            return cell
        }
        // address (coming soon)
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier5, for: indexPath)
            
            if !self.isUpdatingData {
                cell.textLabel?.text = self.selectedDiningLocation.address.street + " " + self.selectedDiningLocation.address.city + " " + self.selectedDiningLocation.address.state + "     "
                
//                cell.textLabel?.addImage(imageName: "navigation-small-2", afterLabel: true)
                
                cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
                
                cell.textLabel?.textAlignment = .center
            }
            else {
                cell.textLabel?.text = ""
            }
            
            return cell
        }
        // capacity
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier3, for: indexPath)
            
            if !self.isUpdatingData {
                if self.capacity != -1 {
                    var label = "Capacity: \(self.capacity)"
                    
                    if self.occupancy != -1 {
                        label += "                        Occupancy: \(self.occupancy)"
                    }
                    else {
                        label += "                        Occupancy: 0"
                    }
                    
                    cell.textLabel?.text = label
                }
            }
            else {
                cell.textLabel?.text = ""
            }
            
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
            cell.isUserInteractionEnabled = false
            
            return cell
            
        }
        // hours
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier4, for: indexPath)
            
            var hours = self.hours
            if hours.count != 0 {
                let tuple = hours[indexPath.row]
                let title = tuple.eventTitle
                let hours = tuple.hours
                
                cell.textLabel?.text = "\(title)  \(hours)"
            }
            else {
                cell.textLabel?.text = ""
            }
            
            cell.isUserInteractionEnabled = false
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier5, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // meals
        if indexPath.section == 0 {
            
//            if self.noMeals {
//                return 44.0
//            }
//            
//            else if self.meals[indexPath.row].courses == nil {
//                return 0
//            }
    
            return 44.0
        }
        // favorite
        else if indexPath.section == 1 {
            return 44.0
        }
        // address
        else if indexPath.section == 2 {
            return 44.0
        }
        // capacity
        else if indexPath.section == 3 {
            return 44.0
        }
        // hours
        else if indexPath.section == 4 {
            return 44.0
        }

        
        // returning 100 for debugging purposes
        return 100.0
    }
    
    // opens the map address on a button press
    func openMapForPlace() {
        
        let coordinate = self.selectedDiningLocation.coordinate
        let latitude: CLLocationDegrees = coordinate.latitude
        let longitude: CLLocationDegrees = coordinate.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
        ] as [String: Any]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.selectedDiningLocation.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selects meal
        if indexPath.section == 0 {
            performSegue(withIdentifier: "SpecificHall_To_Menu", sender: self)
        }
        // select favorites
        else if indexPath.section == 1 {
            self.toggleFavorite()
        }
        // select address
        else if indexPath.section == 2 {
            openMapForPlace()
        }
        else {
            print("Selected a non-important row")
        }
    }
    
    // toggles whether or not a dining halls is a user's favorite
    func toggleFavorite() {
        // change the UI
        // get the cell!
        let cell = tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 1))
        
        let desired_action = cell.textLabel?.text
        
        if desired_action == "Add To Favorites" {
            self.isFavorite = true
            self.tableView.reloadData()
            FavoritesManager.shared.addFavLocation(location: self.selectedDiningLocation.name)
        }
        else {
            self.isFavorite = false
            self.tableView.reloadData()
            FavoritesManager.shared.removeLocation(location: self.selectedDiningLocation.name)
        }
        
        // alter the favorite
        // do something with the favorites manager
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "SpecificHall_To_Menu" {
            if let CoursesTVC = segue.destination as? CoursesTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    // setting back bar item
                    let backItem = UIBarButtonItem()
                    var name = selectedDiningName
                    if name.contains("Dining Hall") {
                        name = name.replacingOccurrences(of: "Dining Hall", with: "")
                    }
                    backItem.title = name
                    navigationItem.backBarButtonItem = backItem

                    if indexPath.section == 0 {
                        if meals[indexPath.row].courses != nil {
                            CoursesTVC.courses = meals[indexPath.row].courses!
                            CoursesTVC.title = "\(meals[indexPath.row].type)"
                            CoursesTVC.atDiningHall = self.selectedDiningLocation
                        }
                        else {
                            CoursesTVC.notServing += "\(meals[indexPath.row].type)"
                            CoursesTVC.servingMeal = "\(meals[indexPath.row].type)"
                            CoursesTVC.title = "\(meals[indexPath.row].type)"
                        }
                    }
                }
            }
        }
    }
}
