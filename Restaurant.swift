//
//  Restaurant.swift
//  SmartResto
//
//  Created by Galin Yonchev on 12/12/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import Foundation

class Restaurant {
    
    var address: String?
    var latitude: Double = 0
    var longitude: Double = 0
    //    var daySchedule: [Dictionary<String, AnyObject>]?
    var email: String?
    var fax: String?
    var id: Int?
    var name: String?
    var phone: String?
    var photoURL: String?
    var descriptionEn : String?
    var descriptionFr : String?
    var howToFindEn: String?
    var howToFindFr: String?
    var photo: UIImage?
    
    // working hours
    var mondayEveningOpen: String = ""
    var mondayEveningClose: String = ""
    var mondayNoonOpen: String = ""
    var mondayNoonClose: String = ""
    var mondaySummary: String = ""
    var tuesdayEveningOpen: String = ""
    var tuesdayEveningClose: String = ""
    var tuesdayNoonOpen: String = ""
    var tuesdayNoonClose: String = ""
    var tuesdaySummary: String = ""
    var wednesdayEveningOpen: String = ""
    var wednesdayEveningClose: String = ""
    var wednesdayNoonOpen: String = ""
    var wednesdayNoonClose: String = ""
    var wednesdaySummary: String = ""
    var thursdayEveningOpen: String = ""
    var thursdayEveningClose: String = ""
    var thursdayNoonOpen: String = ""
    var thursdayNoonClose: String = ""
    var thursdaySummary: String = ""
    var fridayEveningOpen: String = ""
    var fridayEveningClose: String = ""
    var fridayNoonOpen: String = ""
    var fridayNoonClose: String = ""
    var fridaySummary: String = ""
    var saturdayEveningOpen: String = ""
    var saturdayEveningClose: String = ""
    var saturdayNoonOpen: String = ""
    var saturdayNoonClose: String = ""
    var saturdaySummary: String = ""
    var sundayEveningOpen: String = ""
    var sundayEveningClose: String = ""
    var sundayNoonOpen: String = ""
    var sundayNoonClose: String = ""
    var sundaySummary: String = ""
    
    init(json: Dictionary<String, AnyObject>) {
        if let branchName = json["name"] as? String {
            self.name = branchName
        }
        if let branchEmail = json["email"] as? String {
            self.email = branchEmail
        }
        if let branchFax = json["fax"] as? String {
            self.fax = branchFax
        }
        if let branchPhone = json["phone"] as? String {
            self.phone = branchPhone
        }
        
        if let descEn = json["descriptionEn"] as? String {
            self.descriptionEn = descEn
        }
        
        if let descFr = json["descriptionFr"] as? String {
            self.descriptionFr = descFr
        }
        
        if let findEn = json["howToFindEn"] as? String {
            self.howToFindEn = findEn
        }
        
        if let findFr = json["howToFindFr"] as? String {
            self.howToFindFr = findFr
        }
        
        if let branchAddress = json["address"] as? [String: AnyObject] {
            if let address = branchAddress["addrLineOne"] as? String {
                self.address = address
            }
            if let branchLatitude = branchAddress["latitude"] as? String {
                if Double(branchLatitude) != nil {
                    self.latitude = Double(branchLatitude)!
                }
            }
            if let branchLongitude = branchAddress["longitude"] as? String {
                if Double(branchLongitude) != nil {
                    self.longitude = Double(branchLongitude)!
                }
            }
        }
        if let schedule = json["dayschedule"] as? [[String: AnyObject]] {
            self.populateDaySchedule(schedule)
        }
        if let branchID = json["id"] as? Int {
            self.id = branchID
        }
        if let photos = json["photos"] as? [[String: AnyObject]] {
            if let photoURLs: [String: AnyObject] = photos[0] {
                if let photoURL = photoURLs["blobKey"] as? String {
                    self.photoURL = photoURL
                }
            }
        }
    }
    
    //method for storing the timeframes of the working hours of the restaurant
    private func populateDaySchedule(schedule: [[String: AnyObject]]) {
        for day in schedule {
            if let weekDay = day["dayOfWeek"] as? String {
                if let hours = day["hours"] as? [String: AnyObject] {
                    if let openEvening = hours["eveningo"] as? Double, let closeEvening = hours["eveningc"] as? Double , let openNoon = hours["noono"] as? Double, let closeNoon = hours["noonc"] as? Double, let summary = day["oc"] as? String {
                        let openEveningHour = NSDate.timestampToHour(openEvening)
                        let closeEveningHour = NSDate.timestampToHour(closeEvening)
                        let openNoonHour = NSDate.timestampToHour(openNoon)
                        let closeNoonHour = NSDate.timestampToHour(closeNoon)
                        switch (weekDay) {
                        case "MONDAY":
                            self.mondayEveningOpen = openEveningHour
                            self.mondayEveningClose = closeEveningHour
                            self.mondayNoonOpen = openNoonHour
                            self.mondayNoonClose = closeNoonHour
                            self.mondaySummary = summary
                        case "TUESDAY":
                            self.tuesdayEveningOpen = openEveningHour
                            self.tuesdayEveningClose = closeEveningHour
                            self.tuesdayNoonOpen = openNoonHour
                            self.tuesdayNoonClose = closeNoonHour
                            self.tuesdaySummary = summary
                        case "WEDNESDAY":
                            self.wednesdayEveningOpen = openEveningHour
                            self.wednesdayEveningClose = closeEveningHour
                            self.wednesdayNoonOpen = openNoonHour
                            self.wednesdayNoonClose = closeNoonHour
                            self.wednesdaySummary = summary
                        case "THURSDAY":
                            self.thursdayEveningOpen = openEveningHour
                            self.thursdayEveningClose = closeEveningHour
                            self.thursdayNoonOpen = openNoonHour
                            self.thursdayNoonClose = closeNoonHour
                            self.thursdaySummary = summary
                        case "FRIDAY":
                            self.fridayEveningOpen = openEveningHour
                            self.fridayEveningClose = closeEveningHour
                            self.fridayNoonOpen = openNoonHour
                            self.fridayNoonClose = closeNoonHour
                            self.fridaySummary = summary
                        case "SATURDAY":
                            self.saturdayEveningOpen = openEveningHour
                            self.saturdayEveningClose = closeEveningHour
                            self.saturdayNoonOpen = openNoonHour
                            self.saturdayNoonClose = closeNoonHour
                            self.saturdaySummary = summary
                        case "SUNDAY":
                            self.sundayEveningOpen = openEveningHour
                            self.sundayEveningClose = closeEveningHour
                            self.sundayNoonOpen = openNoonHour
                            self.sundayNoonClose = closeNoonHour
                            self.sundaySummary = summary
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    //method for displaying the restaurant's description
    func restaurantDescription() -> String {
        
        let language = NSBundle.mainBundle().preferredLocalizations.first! as String
        var restDescription = ""
        
        if language == "en" {
            restDescription = self.descriptionEn!
        } else {
            restDescription = self.descriptionFr!
        }
        return restDescription
    }
    
    //method for displaying details of how ro reach the restaurant by metro/bus
    func howToCome() -> String {
        
        let language = NSBundle.mainBundle().preferredLocalizations.first! as String
        var howToCome = ""
        
        if language == "en" {
            if (howToFindEn ?? "").isEmpty {
                howToCome = ""
            } else {
                howToCome = self.howToFindEn!
            }
        } else {
            if (howToFindFr ?? "").isEmpty {

            } else {
                howToCome = self.howToFindFr!
            }
        }
        return howToCome
    }

    //method for displaying the working time of the restaurant according to the localisation of the app
    func workingTime() -> String {
        let language = NSBundle.mainBundle().preferredLocalizations.first! as String
        if language == "en" {
            return self.workingTimeEnglish()
        } else {
            return self.workingTimeFrench()
        }
    }
    
    func workingTimeEnglish() -> String {
        let closed = NSLocalizedString("day.closed", comment: "")
        // MONDAY
        let mondayNoon = self.mondayNoonOpen == self.mondayNoonClose ? "\(closed),\t" : "\(self.mondayNoonOpen)" + " - " + "\(self.mondayNoonClose),"
        let mondayEvening = self.mondayEveningOpen == self.mondayEveningClose ? "\(closed)" : "\(self.mondayEveningOpen)" + " - " + "\(self.mondayEveningClose)"
        let monday = self.mondaySummary == "CLOSED" ? NSLocalizedString("day.monday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.monday", comment: "") + "\t\t\t" + "\(mondayNoon)" + "\t" + "\(mondayEvening)"
        // TUESDAY
        let tuesdayNoon = self.tuesdayNoonOpen == self.tuesdayNoonClose ? "\(closed),\t" : "\(self.tuesdayNoonOpen)" + " - " + "\(self.tuesdayNoonClose),"
        let tuesdayEvening = self.tuesdayEveningOpen == self.tuesdayEveningClose ? "\(closed)" : "\(self.tuesdayEveningOpen)" + " - " + "\(self.tuesdayEveningClose)"
        let tuesday = self.tuesdaySummary == "CLOSED" ? NSLocalizedString("day.tuesday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.tuesday", comment: "") + "\t\t\t" + "\(tuesdayNoon)" + "\t" + "\(tuesdayEvening)"
        // WEDNESDAY
        let wednesdayNoon = self.wednesdayNoonOpen == self.wednesdayNoonClose ? "\(closed),\t" : "\(self.wednesdayNoonOpen)" + " - " + "\(self.wednesdayNoonClose),"
        let wednesdayEvening = self.wednesdayEveningOpen == self.wednesdayEveningClose ? "\(closed)" : "\(self.wednesdayEveningOpen)" + " - " + "\(self.wednesdayEveningClose)"
        let wednesday = self.wednesdaySummary == "CLOSED" ? NSLocalizedString("day.wednesday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.wednesday", comment: "") + "\t\t" + "\(wednesdayNoon)" + "\t" + "\(wednesdayEvening)"
        // THURSDAY
        let thursdayNoon = self.thursdayNoonOpen == self.thursdayNoonClose ? "\(closed),\t" : "\(self.thursdayNoonOpen)" + " - " + "\(self.thursdayNoonClose),"
        let thursdayEvening = self.thursdayEveningOpen == self.thursdayEveningClose ? "\(closed)" : "\(self.thursdayEveningOpen)" + " - " + "\(self.thursdayEveningClose)"
        let thursday = self.thursdaySummary == "CLOSED" ? NSLocalizedString("day.thursday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.thursday", comment: "") + "\t\t\t" + "\(thursdayNoon)" + "\t" + "\(thursdayEvening)"
        // FRIDAY
        let fridayNoon = self.fridayNoonOpen == self.fridayNoonClose ? "\(closed),\t" : "\(self.fridayNoonOpen)" + " - " + "\(self.fridayNoonClose),"
        let fridayEvening = self.fridayEveningOpen == self.fridayEveningClose ? "\(closed)" : "\(self.fridayEveningOpen)" + " - " + "\(self.fridayEveningClose)"
        let friday = self.fridaySummary == "CLOSED" ? NSLocalizedString("day.friday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.friday", comment: "") + "\t\t\t" + "\(fridayNoon)" + "\t" + "\(fridayEvening)"
        // SATURDAY
        let saturdayNoon = self.saturdayNoonOpen == self.saturdayNoonClose ? "\(closed),\t" : "\(self.saturdayNoonOpen)" + " - " + "\(self.saturdayNoonClose),"
        let saturdayEvening = self.saturdayEveningOpen == self.saturdayEveningClose ? "\(closed)" : "\(self.saturdayEveningOpen)" + " - " + "\(self.saturdayEveningClose)"
        let saturday = self.saturdaySummary == "CLOSED" ? NSLocalizedString("day.saturday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.saturday", comment: "") + "\t\t\t" + "\(saturdayNoon)" + "\t" + "\(saturdayEvening)"
        // SUNDAY
        let sundayNoon = self.sundayNoonOpen == self.sundayNoonClose ? "\(closed),\t" : "\(self.sundayNoonOpen)" + " - " + "\(self.sundayNoonClose),"
        let sundayEvening = self.sundayEveningOpen == self.sundayEveningClose ? "\(closed)" : "\(self.sundayEveningOpen)" + " - " + "\(self.sundayEveningClose)"
        let sunday = self.sundaySummary == "CLOSED" ? NSLocalizedString("day.sunday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.sunday", comment: "") + "\t\t\t" + "\(sundayNoon)" + "\t" + "\(sundayEvening)"
        // FINAL WORKING TIME
        let workingTime: String = monday + "\n" + tuesday + "\n" + wednesday + "\n" + thursday + "\n" + friday + "\n" + saturday + "\n" + sunday
        return workingTime
    }
    
    func workingTimeFrench() -> String {
        let closed = NSLocalizedString("day.closed", comment: "")
        // MONDAY
        let mondayNoon = self.mondayNoonOpen == self.mondayNoonClose ? "\(closed),\t" : "\(self.mondayNoonOpen)" + " - " + "\(self.mondayNoonClose),"
        let mondayEvening = self.mondayEveningOpen == self.mondayEveningClose ? "\(closed)" : "\(self.mondayEveningOpen)" + " - " + "\(self.mondayEveningClose)"
        let monday = self.mondaySummary == "CLOSED" ? NSLocalizedString("day.monday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.monday", comment: "") + "\t\t\t" + "\(mondayNoon)" + "\t" + "\(mondayEvening)"
        // TUESDAY
        let tuesdayNoon = self.tuesdayNoonOpen == self.tuesdayNoonClose ? "\(closed),\t" : "\(self.tuesdayNoonOpen)" + " - " + "\(self.tuesdayNoonClose),"
        let tuesdayEvening = self.tuesdayEveningOpen == self.tuesdayEveningClose ? "\(closed)" : "\(self.tuesdayEveningOpen)" + " - " + "\(self.tuesdayEveningClose)"
        let tuesday = self.tuesdaySummary == "CLOSED" ? NSLocalizedString("day.tuesday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.tuesday", comment: "") + "\t\t\t" + "\(tuesdayNoon)" + "\t" + "\(tuesdayEvening)"
        // WEDNESDAY
        let wednesdayNoon = self.wednesdayNoonOpen == self.wednesdayNoonClose ? "\(closed),\t" : "\(self.wednesdayNoonOpen)" + " - " + "\(self.wednesdayNoonClose),"
        let wednesdayEvening = self.wednesdayEveningOpen == self.wednesdayEveningClose ? "\(closed)" : "\(self.wednesdayEveningOpen)" + " - " + "\(self.wednesdayEveningClose)"
        let wednesday = self.wednesdaySummary == "CLOSED" ? NSLocalizedString("day.wednesday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.wednesday", comment: "") + "\t\t\t" + "\(wednesdayNoon)" + "\t" + "\(wednesdayEvening)"
        // THURSDAY
        let thursdayNoon = self.thursdayNoonOpen == self.thursdayNoonClose ? "\(closed),\t" : "\(self.thursdayNoonOpen)" + " - " + "\(self.thursdayNoonClose),"
        let thursdayEvening = self.thursdayEveningOpen == self.thursdayEveningClose ? "\(closed)" : "\(self.thursdayEveningOpen)" + " - " + "\(self.thursdayEveningClose)"
        let thursday = self.thursdaySummary == "CLOSED" ? NSLocalizedString("day.thursday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.thursday", comment: "") + "\t\t\t" + "\(thursdayNoon)" + "\t" + "\(thursdayEvening)"
        // FRIDAY
        let fridayNoon = self.fridayNoonOpen == self.fridayNoonClose ? "\(closed),\t" : "\(self.fridayNoonOpen)" + " - " + "\(self.fridayNoonClose),"
        let fridayEvening = self.fridayEveningOpen == self.fridayEveningClose ? "\(closed)" : "\(self.fridayEveningOpen)" + " - " + "\(self.fridayEveningClose)"
        let friday = self.fridaySummary == "CLOSED" ? NSLocalizedString("day.friday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.friday", comment: "") + "\t\t\t" + "\(fridayNoon)" + "\t" + "\(fridayEvening)"
        // SATURDAY
        let saturdayNoon = self.saturdayNoonOpen == self.saturdayNoonClose ? "\(closed),\t" : "\(self.saturdayNoonOpen)" + " - " + "\(self.saturdayNoonClose),"
        let saturdayEvening = self.saturdayEveningOpen == self.saturdayEveningClose ? "\(closed)" : "\(self.saturdayEveningOpen)" + " - " + "\(self.saturdayEveningClose)"
        let saturday = self.saturdaySummary == "CLOSED" ? NSLocalizedString("day.saturday", comment: "") + "\t\t\t\(closed)" : NSLocalizedString("day.saturday", comment: "") + "\t\t\t" + "\(saturdayNoon)" + "\t" + "\(saturdayEvening)"
        // SUNDAY
        let sundayNoon = self.sundayNoonOpen == self.sundayNoonClose ? "\(closed),\t" : "\(self.sundayNoonOpen)" + " - " + "\(self.sundayNoonClose),"
        
        let sundayEvening = self.sundayEveningOpen == self.sundayEveningClose ? "\(closed)" : "\(self.sundayEveningOpen)" + " - " + "\(self.sundayEveningClose)"
        var sunday = ""
        
        if DeviceType.IS_IPHONE_6P {
             sunday = self.sundaySummary == "CLOSED" ? NSLocalizedString("day.sunday", comment: "") + "\t\t\(closed)" : NSLocalizedString("day.sunday", comment: "") + "\t\t" + "\(sundayNoon)" + "\t" + "\(sundayEvening)"
        } else {
             sunday = self.sundaySummary == "CLOSED" ? NSLocalizedString("day.sunday", comment: "") + "\t\t\(closed)" : NSLocalizedString("day.sunday", comment: "") + "\t\t" + "\(sundayNoon)" + "\t" + "\(sundayEvening)"
        }
        // FINAL WORKING TIME
        let workingTime: String = monday + "\n" + tuesday + "\n" + wednesday + "\n" + thursday + "\n" + friday + "\n" + saturday + "\n" + sunday
        return workingTime
    }
    
}

