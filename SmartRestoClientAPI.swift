//
//  SmartRestoClientAPI.swift
//  SmartResto
//
//  Created by Galin Yonchev on 12/12/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import Foundation
import Alamofire

class SmartRestoClientAPI {
    
    let baseURLString: String = "http://admin.smartresto.fr/rest"
    
    class var sharedInstance: SmartRestoClientAPI {
        struct Static {
            static var instance: SmartRestoClientAPI?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = SmartRestoClientAPI()
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Accept": "application/json", "Content-type": "application/json"]
        }
        return Static.instance!
    }
    
    //method for loading branch details
    func getBranchDetails(branchID: Int, success: ((branch: Restaurant) -> Void)?, failure: ((NSError) -> Void)?) {
        
        Alamofire.request(.GET, baseURLString + "/branch/getById/\(branchID)", parameters: nil).responseJSON { (response) -> Void in
            
            print(response.result.value)
            if let result = response.result.value {
                let restaurant = Restaurant(json: result as! Dictionary<String, AnyObject>)
                let resultData = NSKeyedArchiver.archivedDataWithRootObject(result)
                if branchID == Constants.RestaurantsIDs.CaveGaribaldi {
                    self.saveJSONRestaurantWithData(resultData, name: "LaCaveGaribaldi")
                } else if branchID == Constants.RestaurantsIDs.CommuneImage {
                    self.saveJSONRestaurantWithData(resultData, name: "CommuneImage")
                }
                success!(branch: restaurant)
            }
            if let error = response.result.error {
                failure!(error)
            }
        }
    }
    
    //method for loading news of a branch
    func getBranchNews(branchID: Int, success: ((news: [News]) -> Void)?, failure: ((NSError) -> Void)?) {
        
        Alamofire.request(.GET, baseURLString + "/article/getAllByBranch/\(branchID)", parameters: nil).responseJSON { (response) -> Void in
//            print(response.result.value)
            if let result = response.result.value as? [[String: AnyObject]] {
                var newsArray: [News] = []
                for res in result {
                    let news = News(json: res)
                    newsArray.append(news)
                }
                
                let resultData = NSKeyedArchiver.archivedDataWithRootObject(result)
                if branchID == Constants.RestaurantsIDs.CaveGaribaldi {
                    self.saveJSONNewsWithData(resultData, name: "LaCaveGaribaldi")
                } else if branchID == Constants.RestaurantsIDs.CommuneImage {
                    self.saveJSONNewsWithData(resultData, name: "CommuneImage")
                }
                success!(news: newsArray)
            }
            if let error = response.result.error {
                failure!(error)
            }
        }
    }
    
    //method for loading the branch menu
    func getBranchMenu(branchID: Int, success: ((branchMenu: Menu) -> Void)?, failure: ((NSError) -> Void)?) {
        Alamofire.request(.GET, baseURLString + "/branch/menu/\(branchID)", parameters: nil).responseJSON { (response) -> Void in
            
//            print(response.result.value)
            if let result = response.result.value as? [[String : AnyObject]] {
                let menu = Menu(json: result)
                
                success!(branchMenu: menu)
            }
            if let error = response.result.error {
                failure!(error)
            }
        }
    }
    
    //method for loading reservations by their ID
    func getReservationByID(reservationID: Int, success: ((reservation: Reservation) -> Void)?, failure: ((NSError) -> Void)?) {
        Alamofire.request(.GET, baseURLString + "/reservation/getById/\(reservationID)", parameters: nil).responseJSON { (response) -> Void in
            
//            print(response.result.value)
            if let result = response.result.value as? [String: AnyObject] {
                let reservation = Reservation(json: result)
                
                success!(reservation: reservation)
            }
            if let error = response.result.error {
                failure!(error)
            }
        }
    }
    
    //method for creating reservation
    func createReservation(restaurantID: Int, date: Double, email: String, firstName: String, lastName: String, address: String, phone: String, couverts: Int, comments: String, pushToken: String,language: String, success: ((reservation: Reservation) -> Void)?, failure: ((NSError) -> Void)?) {
        
        let params = [
            "idBranch": restaurantID,
            "date": date,
            "email": email,
            "firstname": firstName,
            "lastname": lastName,
            "address": address,
            "phone": phone,
            "couverts": couverts,
            "comments": comments,
            "pushToken" : pushToken,
            "language" : language
        ]
        
        Alamofire.request(.POST, baseURLString + "/reservation", parameters: params as? [String : AnyObject], encoding: .JSON).responseJSON { (response) -> Void in
//            print(response.result.value)
            if let result = response.result.value as? [String: AnyObject] {
                let reservation = Reservation(json: result)
                reservation.restaurant = Manager.sharedInstance.restaurantName
                success!(reservation: reservation)
            }
            if let error = response.result.error {
                failure!(error)
            }
        }
    }
    
    //methods for caching the restaurant details
    private func saveJSONRestaurantWithData(JSON: NSData, name: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let filePath: String = documentsDirectory.stringByAppendingPathComponent("\(name).json")
        JSON.writeToFile(filePath, atomically: true)
    }
    
    func readLocalRestaurant(name: String) -> Restaurant? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let filePath: String = documentsDirectory.stringByAppendingPathComponent("\(name).json")
        let checkValidation = NSFileManager.defaultManager()
        if checkValidation.fileExistsAtPath(filePath) {
            let storedData = NSData(contentsOfFile: filePath)
            let dictionary: [String: AnyObject] = NSKeyedUnarchiver.unarchiveObjectWithData(storedData!) as! [String: AnyObject]
            let restaurant = Restaurant(json: dictionary)
            return restaurant
        }
        return nil
    }
    
    //methods for caching the news of a branch
    private func saveJSONNewsWithData(JSON: NSData, name: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let filePath: String = documentsDirectory.stringByAppendingPathComponent("\(name)-News.json")
        JSON.writeToFile(filePath, atomically: true)
    }
    
    func readLocalNews(name: String) -> [News] {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let filePath: String = documentsDirectory.stringByAppendingPathComponent("\(name)-News.json")
        let checkValidation = NSFileManager.defaultManager()
        if checkValidation.fileExistsAtPath(filePath) {
            let storedData = NSData(contentsOfFile: filePath)
            let newsData: [[String: AnyObject]] = NSKeyedUnarchiver.unarchiveObjectWithData(storedData!) as! [[String: AnyObject]]
            var newsArray = [News]()
            for res in newsData {
                let news = News(json: res)
                newsArray.append(news)
            }
            return newsArray
        }
        return [News]()
    }
}

