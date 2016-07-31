//
//  Reservation.swift
//  SmartResto
//
//  Created by Galin Yonchev on 12/12/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import Foundation

class Reservation: NSObject, NSCoding {
 
    var id: Int?
    var date: Double?
    var email: String?
    var firstName: String?
    var lastName: String?
    var address: String?
    var phone: String?
    var couverts: Int?
    var comments: String?
    var reservationType: String?
    var pushToken: String?
    var restaurant: String!
    
    init(json: [String: AnyObject]) {
        if let reservationID = json["id"] as? Int {
            self.id = reservationID
        }
        if let dateReservation = json["date"] as? Double {
            self.date = dateReservation
        }
        if let emailCustomer = json["email"] as? String {
            self.email = emailCustomer
        }
        if let firstName = json["firstname"] as? String {
            self.firstName = firstName
        }
        if let lastName = json["lastname"] as? String {
            self.lastName = lastName
        }
        if let addressCustomer = json["address"] as? String {
            self.address = addressCustomer
        }
        if let phoneCustomer = json["phone"] as? String {
            self.phone = phoneCustomer
        }
        if let couvertsCustomer = json["couverrts"] as? Int {
            self.couverts = couvertsCustomer
        }
        if let commentsCustomer = json["comments"] as? String {
            self.comments = commentsCustomer
        }
        if let reservationCustomer = json["reservationType"] as? String {
            self.reservationType = reservationCustomer
        }
        //adding
        if let pushTokenCustomer = json["pushToken"] as? String {
            self.pushToken = pushTokenCustomer
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.firstName = aDecoder.decodeObjectForKey("firstName") as? String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as? String
        self.address = aDecoder.decodeObjectForKey("address") as? String
        self.email = aDecoder.decodeObjectForKey("email") as? String
        self.couverts = aDecoder.decodeObjectForKey("couverts") as? Int
        self.comments = aDecoder.decodeObjectForKey("comments") as? String
        self.id = aDecoder.decodeObjectForKey("id") as? Int
        self.reservationType = aDecoder.decodeObjectForKey("reservationType") as? String
        self.phone = aDecoder.decodeObjectForKey("phone") as? String
        self.date = aDecoder.decodeObjectForKey("date") as? Double
        //adding
        self.pushToken = aDecoder.decodeObjectForKey("pushToken") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.firstName, forKey: "firstName")
        aCoder.encodeObject(self.lastName, forKey: "lastName")
        aCoder.encodeObject(self.address, forKey: "address")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.couverts, forKey: "couverts")
        aCoder.encodeObject(self.comments, forKey: "comments")
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.reservationType, forKey: "reservationType")
        aCoder.encodeObject(self.phone, forKey: "phone")
        aCoder.encodeObject(self.date, forKey: "date")
        //adding
        aCoder.encodeObject(self.pushToken, forKey: "pushToken")
    }
    
    //save all the reservations in NSUserDefaults
    func saveLocally() {
        var reservations = self.loadReservations()
        reservations.append(self)
        reservations.sortInPlace({$0.date! < $1.date!})
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userData = NSKeyedArchiver.archivedDataWithRootObject(reservations)
        if Manager.sharedInstance.restaurantName == "Commune Image" {
            userDefaults.setObject(userData, forKey: "Reservations-CI")
            userDefaults.synchronize()
        } else if Manager.sharedInstance.restaurantName == "La Cave Garibaldi" {
            userDefaults.setObject(userData, forKey: "Reservations-CG")
            userDefaults.synchronize()
        }

    }
    
    //method for loading all the reservations
    func loadReservations() -> [Reservation] {
        let reservs = [Reservation]()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if Manager.sharedInstance.restaurantName == "Commune Image" {
            if userDefaults.objectForKey("Reservations-CI") != nil {
                if let reservationsData = userDefaults.objectForKey("Reservations-CI") as? NSData {
                    if let reservations = NSKeyedUnarchiver.unarchiveObjectWithData(reservationsData) as? [Reservation] {
                        return reservations
                    }
                }
            }
        } else if Manager.sharedInstance.restaurantName == "La Cave Garibaldi" {
            if userDefaults.objectForKey("Reservations-CG") != nil {
                if let reservationsData = userDefaults.objectForKey("Reservations-CG") as? NSData {
                    if let reservations = NSKeyedUnarchiver.unarchiveObjectWithData(reservationsData) as? [Reservation] {
                        return reservations
                    }
                }
            }
        }
        return reservs
    }
    
    //method for deleting a reservation
    class func deleteReservation(index: Int) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if Manager.sharedInstance.restaurantName == "Commune Image" {
            if userDefaults.objectForKey("Reservations-CI") != nil {
                if let reservationsData = userDefaults.objectForKey("Reservations-CI") as? NSData {
                    if var reservations = NSKeyedUnarchiver.unarchiveObjectWithData(reservationsData) as? [Reservation] {
                        reservations.sortInPlace({$0.date! < $1.date!})
                        // remove reservation
                        reservations.removeAtIndex(index)
                        // save again to user defaults
                        let userData = NSKeyedArchiver.archivedDataWithRootObject(reservations)
                        userDefaults.setObject(userData, forKey: "Reservations-CI")
                        userDefaults.synchronize()
                    }
                }
            }
        } else if Manager.sharedInstance.restaurantName == "La Cave Garibaldi" {
            if userDefaults.objectForKey("Reservations-CG") != nil {
                if let reservationsData = userDefaults.objectForKey("Reservations-CG") as? NSData {
                    if var reservations = NSKeyedUnarchiver.unarchiveObjectWithData(reservationsData) as? [Reservation] {
                        reservations.sortInPlace({$0.date! < $1.date!})
                        // remove reservation
                        reservations.removeAtIndex(index)
                        // save again to user defaults
                        let userData = NSKeyedArchiver.archivedDataWithRootObject(reservations)
                        userDefaults.setObject(userData, forKey: "Reservations-CG")
                        userDefaults.synchronize()
                    }
                }
            }

        }

    }
    
    func getDateAndHour() -> String {
        if self.date != nil {
            let currentDate: NSDate = NSDate.timestampToDate(self.date!)
            let date = currentDate.getDateAndMonth()
            let hour = currentDate.getHourAndMinutes()
            return date + ", " + hour
        }
        return ""
    }

    class func deleteOldReservations() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if Manager.sharedInstance.restaurantName == "Commune Image" {
            if userDefaults.objectForKey("Reservations-CI") != nil {
                if let reservationsData = userDefaults.objectForKey("Reservations-CI") as? NSData {
                    if var reservations = NSKeyedUnarchiver.unarchiveObjectWithData(reservationsData) as? [Reservation] {
                        for var i = 0; i < reservations.count; i++ {
                            if NSDate.timestampToDate(reservations[i].date!).isLessThanDate(NSDate()) {
                                reservations.removeAtIndex(i)
                            }
                        }
                        let userData = NSKeyedArchiver.archivedDataWithRootObject(reservations)
                        userDefaults.setObject(userData, forKey: "Reservations-CI")
                        userDefaults.synchronize()
                    }
                }
            }
        } else if Manager.sharedInstance.restaurantName == "La Cave Garibaldi" {
            if userDefaults.objectForKey("Reservations-CG") != nil {
                if let reservationsData = userDefaults.objectForKey("Reservations-CG") as? NSData {
                    if var reservations = NSKeyedUnarchiver.unarchiveObjectWithData(reservationsData) as? [Reservation] {
                        for var i = 0; i < reservations.count; i++ {
                            if NSDate.timestampToDate(reservations[i].date!).isLessThanDate(NSDate()) {
                                reservations.removeAtIndex(i)
                            }
                        }
                        let userData = NSKeyedArchiver.archivedDataWithRootObject(reservations)
                        userDefaults.setObject(userData, forKey: "Reservations-CG")
                        userDefaults.synchronize()
                    }
                }
            }
        }
    }

}