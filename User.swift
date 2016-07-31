//
//  User.swift
//  SmartResto
//
//  Created by Galin Yonchev on 1/11/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {

    var firstName: String!
    var lastName: String!
    var address: String!
    var postalCode: String!
    var email: String!
    var phoneNumber: String!
    var pushEnabled: Bool = false
    
    init(firstName: String, lastName: String, address: String, postalCode: String, email: String, phoneNumber: String, pushEnabled: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.postalCode = postalCode
        self.email = email
        self.phoneNumber = phoneNumber
        self.pushEnabled = pushEnabled
    }
    
    required init(coder aDecoder: NSCoder) {
        self.firstName = aDecoder.decodeObjectForKey("firstName") as! String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as! String
        self.address = aDecoder.decodeObjectForKey("address") as! String
        self.postalCode = aDecoder.decodeObjectForKey("postalCode") as! String
        self.email = aDecoder.decodeObjectForKey("email") as! String
        self.phoneNumber = aDecoder.decodeObjectForKey("phoneNumber") as! String
        self.pushEnabled = aDecoder.decodeObjectForKey("pushEnabled") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.firstName, forKey: "firstName")
        aCoder.encodeObject(self.lastName, forKey: "lastName")
        aCoder.encodeObject(self.address, forKey: "address")
        aCoder.encodeObject(self.postalCode, forKey: "postalCode")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encodeObject(self.pushEnabled, forKey: "pushEnabled")
    }
    
    //method for loading the user from NSUserDefaults
    class func loadUser() -> User? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("User") != nil {
            if let userData = userDefaults.objectForKey("User") as? NSData {
                if let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as? User {
                    return user
                }
            }
        }
        return nil
    }
    
    //saving user to NSUserDefaults
    func saveUser() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userData = NSKeyedArchiver.archivedDataWithRootObject(self)
        userDefaults.setObject(userData, forKey: "User")
        userDefaults.synchronize()
    }
    
    func mainDataIsPopulated() -> Bool {
        if self.firstName.isEmpty || self.lastName.isEmpty || self.email.isEmpty || self.phoneNumber.isEmpty || self.address.isEmpty {
            return false
        } else {
            return true
        }
    }
    
}