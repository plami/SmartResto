//
//  Menu.swift
//  SmartResto
//
//  Created by Galin Yonchev on 12/12/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import Foundation

class Menu {
    
    var dish: [String] = []
    var dishName: [String] = []
    var dishDescription: [String] = []
    var dishPrice: [String] = []
    var dishResidentRate: [String] = []
    var dishCategory: [String] = []
    
    init(json: [[String: AnyObject]]) {
        
        for var i = 0; i < json.count; ++i {
            
            if let categories:[String: AnyObject] = json[i] {
                if let dishCategories = categories["rowCells"]! as? [[String: AnyObject]] {
                    if let dishCategory: [String:AnyObject] = dishCategories[0] {
                        if let dishCategorySecond = dishCategory["value"] as? String {
                            if(dishCategorySecond ?? "").isEmpty || dishCategorySecond.characters.count == 0{
                                self.dishCategory.append(dishCategorySecond)
                                self.dish.append(dishCategorySecond)
                            } else {
                                self.dishCategory.append(dishCategorySecond)
                                self.dish.append(dishCategorySecond)
                            }
                        }
                    }
                }
            }
            if let names: [String: AnyObject] = json[i] {
                if let dishNames = names["rowCells"]! as? [[String: AnyObject]] {
                    if let dishName: [String:AnyObject] = dishNames[1] {
                        if let dishNameSecond = dishName["value"] as? String {
                            self.dishName.append(dishNameSecond)
                        }
                    }
                }
            }
            
            if let descriptions: [String: AnyObject] = json[i] {
                if let dishDescriptions = descriptions["rowCells"]! as? [[String: AnyObject]] {
                    if let dishDescription: [String:AnyObject] = dishDescriptions[2] {
                        if let dishDescriptionSecond = dishDescription["value"] as? String {
                            self.dishDescription.append(dishDescriptionSecond)
                            self.dish.append(dishDescriptionSecond)
                        }
                    }
                }
            }
            
            if let prices: [String: AnyObject] = json[i] {
                if let dishPrices = prices["rowCells"]! as? [[String: AnyObject]] {
                    if let dishPrice: [String:AnyObject] = dishPrices[3] {
                        if let dishPriceSecond = dishPrice["value"] as? String {
                            self.dishPrice.append(dishPriceSecond)
                            self.dish.append(dishPriceSecond)
                        }
                    }
                }
            }
            
            if let residentRates: [String: AnyObject] = json[i] {
                if let dishResidentRates = residentRates["rowCells"]! as? [[String: AnyObject]] {
                    if let dishResidentRate: [String:AnyObject] = dishResidentRates[4] {
                        if let dishResidentRateSecond = dishResidentRate["value"] as? String {
                            self.dishResidentRate.append(dishResidentRateSecond)
                            self.dish.append(dishResidentRateSecond)
                        }
                    }
                }
            }
        }
    }
}

