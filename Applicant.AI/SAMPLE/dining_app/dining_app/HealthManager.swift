////
////  HealthManager.swift
////  dining_app
////
////  Created by Jordan Wolff on 3/29/17.
////  Copyright © 2017 Jordan Wolff. All rights reserved.
////
//
//import Foundation
//import HealthKit
//
//class HealthManager {
//    
//    let healthKitStore: HKHealthStore = HKHealthStore()
//    
//    func authorizeHealthKit(completion: ((_ success: Bool, _ error: Error?) -> Void)!) {
//        
//        // State the health data type(s) we want to write from HealthKit.
//        let healthDataToWrite = Set(arrayLiteral: [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCalcium),
//                                                   HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryIron),
//                                                   HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryZinc),
//                                                   HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber),
//                                                   HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar),
//                                                   HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySodium),
//                                                   HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein),
//                                                   HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal),
//                                                   HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietary)//HKQuantityTypeIdentifierDistanceWalkingRunning)!)
//        
//        // Just in case OneHourWalker makes its way to an iPad...
//        if !HKHealthStore.isHealthDataAvailable() {
//            print("Can't access HealthKit.")
//        }
//        
//        // Request authorization to read and/or write the specific data.
//        healthKitStore.requestAuthorizationToShareTypes(healthDataToWrite, readTypes: healthDataToRead) { (success, error) -> Void in
//            if( completion != nil ) {
//                completion(success:success, error:error)
//            }
//        }
//    }
//    
//    
//}
