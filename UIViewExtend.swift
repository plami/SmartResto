//
//  backgroundImage.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 12/10/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import Foundation

extension UIView {
    
    func addBackground() {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        var height = UIScreen.mainScreen().bounds.size.height

        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        
        switch height {
        case 1:
            height = 568.0
            imageViewBackground.image = UIImage(named: "home-568h@2.png")
            
        case 2:
            height = 667.0
            imageViewBackground.image = UIImage(named: "home-667h@2.png")
            
        case 3:
            height = 736.0
            imageViewBackground.image = UIImage(named: "home-736h@3x.png")

        default:
            imageViewBackground.image = UIImage(named: "home.png")
        }
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
    

    func addWhiteBackground() {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
            
            let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
            imageViewBackground.backgroundColor = UIColor.whiteColor()
        
            // you can change the content mode:
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
            
            self.addSubview(imageViewBackground)
            self.sendSubviewToBack(imageViewBackground)
    }
    
    func setupBackground() {
        if Manager.sharedInstance.restaurantName == Constants.RestaurantsNames.CaveGaribaldiRestaurant {
            self.addWhiteBackground()
        } else {
            self.addBackground()
        }
    }
}