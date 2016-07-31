//
//  Manager.swift
//  SmartResto
//
//  Created by Galin Yonchev on 1/7/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import Foundation

class Manager {
    
    var restaurantName: String = ""
    var restaurant: Restaurant?
    var reservations: [Reservation] = []
    var menu: Menu?
    var news: News?
    
    class var sharedInstance: Manager {
        struct Static {
            static var instance: Manager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = Manager()
        }
        return Static.instance!
    }
    
    func getLogo() -> UIImage {
        if self.restaurantName == Constants.RestaurantsNames.CommuneImageRestaurant {
            return UIImage(named: "CommuneImage")!
        } else if self.restaurantName == Constants.RestaurantsNames.CaveGaribaldiRestaurant {
            return UIImage(named: "CaveGaribaldiLogo")!
        }
        return UIImage(named: "CommuneImage")!
    }
    
    func loadReservationIDs() -> [Int] {
        var uniqueIDs = [Int]()
        Reservation.deleteOldReservations()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if Manager.sharedInstance.restaurantName == "Commune Image" {
            if userDefaults.objectForKey("Reservations-CI") != nil {
                if let reservationsData = userDefaults.objectForKey("Reservations-CI") as? NSData {
                    if let reservations = NSKeyedUnarchiver.unarchiveObjectWithData(reservationsData) as? [Reservation] {
                        for res in reservations {
                            uniqueIDs.append(res.id!)
                        }
                        return uniqueIDs
                    }
                }
            }
        } else if Manager.sharedInstance.restaurantName == "La Cave Garibaldi" {
            if userDefaults.objectForKey("Reservations-CG") != nil {
                if let reservationsData = userDefaults.objectForKey("Reservations-CG") as? NSData {
                    if let reservations = NSKeyedUnarchiver.unarchiveObjectWithData(reservationsData) as? [Reservation] {
                        for res in reservations {
                            uniqueIDs.append(res.id!)
                        }
                        return uniqueIDs
                    }
                }
            }
        }
        return uniqueIDs
    }
    
}