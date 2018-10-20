//
//  AppDelegate.swift
//  dining_app
//
//  Created by Jordan Wolff on 2/28/17.
//  Copyright © 2017 Jordan Wolff. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Background Fetch
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        
        // Notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization.
            if((error == nil)) {
                print("Request authorization failed! But notifications may already be enabled!")
            } else {
                print("Request authorization succeeded!")
                self.showAlert()
            }
        }
        
        return true
    }
    
    func showAlert() {
        let objAlert = UIAlertController(title: "Notifications", message: "Successfully subscribed to notifications, now you'll receive updates when a dining location is serving your favorite foods!", preferredStyle: UIAlertControllerStyle.alert)
        
        objAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //self.presentViewController(objAlert, animated: true, completion: nil)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(objAlert, animated: true, completion: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("In Background!")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        var sentNotification = false
        
        let favoriteMenuItems = UserDefaults.standard.object(forKey: "favoriteItems") as? [String] ?? [String]()
        
        // we can only look for notifications if the user has favorites set!
        if favoriteMenuItems.count != 0 {
            MenusAPIManager.getDiningLocations { (locations) in
                print("In API 1")
  
                for location in locations {
                    if sentNotification {
                        break
                    }
                    if !sentNotification {
                        MenusAPIManager.getMeals(for: location, completionHandler: { (mealsToLoad) in
                            
                            print("Checking \(location.name)...")
                            
                            let meals = mealsToLoad
                            
                            var foundItem = ""
                            var foundItemLocation = ""
                            var foundItemMeal = ""
                            
                            var encountered = Set<String>()
                            var foundItems = [String:[String]]()
                            
                            
                            // go through every favorite
                            // if served at a dining hall, add it to servedToday
                            for item in favoriteMenuItems {
                                for meal in meals {
                                    if let courses = meal.courses {
                                        for course in courses {
                                            for menuItem in course.menuItems {
                                                if menuItem.name == item {
                                                    if !encountered.contains(item) {
                                                        foundItem = item
                                                        foundItemLocation = location.name
                                                        foundItemMeal = meal.type.rawValue
                                                        
                                                        foundItems[item] = []
                                                        foundItems[item]?.append(foundItemLocation)
                                                        foundItems[item]?.append(foundItem)
                                                        foundItems[item]?.append(foundItemMeal)
                                                        
                                                        encountered.insert(item)
                                                        
                                                        print("Found \(item)!!!")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            // now choose a random item and send a notification
                            let keys = Array(foundItems.keys)
                            
                            if keys.count != 0 {
                                let randomIndex = Int(arc4random_uniform(UInt32(keys.count - 1)))
                                
                                let randomItemName = keys[randomIndex]
                                
                                let count = foundItems[randomItemName]!.count
                                
                                var bodyText = "\((foundItems[randomItemName]?[0])!) "
                                if count > 3 {
                                    bodyText += "and more are "
                                }
                                else {
                                    bodyText += "is "
                                }
                                bodyText += "serving \(randomItemName) for \((foundItems[randomItemName]?[2])!) today!"
                                
                                // configure a notification based on the randomItem
                                let content = UNMutableNotificationContent()
                                content.title = NSString.localizedUserNotificationString(forKey: "Found Favorite Menu Item!", arguments: nil)
                                content.body = NSString.localizedUserNotificationString(forKey: bodyText, arguments: nil)
                                content.sound = UNNotificationSound.default()
                                content.categoryIdentifier = "MenuItem"
                                
                                // send notification in 5 seconds
                                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
                                let request = UNNotificationRequest.init(identifier: "MenuItem", content: content, trigger: trigger)
                                
                                let center = UNUserNotificationCenter.current()
                                center.add(request)
                                sentNotification = true
                                
                                if sentNotification {
                                    completionHandler(UIBackgroundFetchResult.newData)
                                }
                                else {
                                    completionHandler(UIBackgroundFetchResult.noData)
                                }
                            }

                            
                        }) // getMeals
                    }
                }
            } // getDiningLocations
        }
    }


}

