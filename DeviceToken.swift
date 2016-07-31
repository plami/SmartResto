//
//  DeviceToken.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 2/24/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import Foundation

class DeviceToken: NSObject, NSCoding {
    
    var pushToken : String!
    
    init(pushToken : String) {
        self.pushToken = pushToken
    }
    
    required init(coder aDecoder: NSCoder) {
        self.pushToken = aDecoder.decodeObjectForKey("pushToken") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.pushToken, forKey: "pushToken")
    }
    
    //saving the device token in NSUserDefaults -> for push notifications
    func saveToken() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let tokenData = NSKeyedArchiver.archivedDataWithRootObject(self)
        userDefaults.setObject(tokenData, forKey: "PushToken")
        userDefaults.synchronize()
    }
    
    //method for loading the device token
    class func loadToken() -> DeviceToken? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("PushToken") != nil {
            if let tokenData = userDefaults.objectForKey("PushToken") as? NSData {
                if let token = NSKeyedUnarchiver.unarchiveObjectWithData(tokenData) as? DeviceToken {
                    return token
                }
            }
        }
        return nil
    }
}