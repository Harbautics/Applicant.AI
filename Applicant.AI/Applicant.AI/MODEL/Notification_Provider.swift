//
//  Notification_Provider.swift
//  Applicant.AI
//
//  Created by Jordan Wolff on 11/25/18.
//  Copyright © 2018 Harbautics. All rights reserved.
//

import Foundation

class Notification_Provider {
    
    var playerID = String()
    
    static let shared = Notification_Provider()
    
    let defaults = UserDefaults.standard
    
    private init() {
        self.playerID = self.defaults.object(forKey: "playerID") as? String ?? "no playerID"
        
        // notification
        let notificationName = NSNotification.Name("playerIDFound")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func setPlayerID(newID: String) {
        self.playerID = newID
        
        let encodedData = newID
        self.defaults.set(encodedData, forKey: "playerID")
        self.defaults.synchronize()
    }

    func getPlayerID() -> String {
        return self.playerID
    }
}

