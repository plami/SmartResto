//
//  Constants.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 1/18/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}


struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

import Foundation

struct Constants {
    
    struct RestaurantsNames {
        
        static let CaveGaribaldiRestaurant = "La Cave Garibaldi"
        static let CommuneImageRestaurant = "Commune Image"
    }
    
    struct RestaurantsIDs {
        
        static let CaveGaribaldi = 51
        static let CommuneImage = 53
    }
    
    struct Controllers {
        
        static let mainViewController = "MainMenuViewController"
        static let restaurantMainViewController = "RestaurantMenuViewController"
        static let bookingViewController = "BookingViewController"
        static let myAccountViewController = "MyAccountViewController"
        static let restaurantsViewController = "RestaurantsViewController"
        static let helpViewController = "HelpViewController"
        static let legalNoticeViewController = "LegalNoticeViewController"
    }
    
    struct HeaderView {
        
        static let imageHeight: CGFloat = 150
        static let imageWidth: CGFloat = 180
        static let labelHeight: CGFloat = 30
        static let constantImageLogo: CGFloat = 24
        static let constImageLogo : CGFloat = 2
        static let constantLblHeading: CGFloat = 12
        static let constLbl: CGFloat = 1
        static let constantFrame : CGFloat = 240
        static let constantZeroFrame : CGFloat = 0
        static let fontLbl : CGFloat = 20
    }
    
    struct FooterView {
        
        static let btnHeight: CGFloat = 34
        static let btnWidth: CGFloat = 166
        static let constantFrame : CGFloat = 60
        static let constantZeroFrame : CGFloat = 0
        static let constantFrameSecond : CGFloat = 10
        static let fontLbl : CGFloat = 16
        static let constCornerRadius : CGFloat = 0.1
        static let constButtonFrame : CGFloat = 2
    }
    
    struct MyReservationTableViewCell {
        
        static let constBorderWidth : CGFloat = 1
        static let constContainer : CGFloat = 0.03
        static let constImageContainer : CGFloat = 0.2
    }
    
    struct DetailsViewController {
        
        static let constCloseButtonFrame : CGFloat = 30
        static let constCloseButtonZeroFrame : CGFloat = 0
        static let constButtonBookingCornerRadius : CGFloat = 0.1
    }
    
    struct LocationViewController {
        
        static let constCloseButtonFrame : CGFloat = 30
        static let constCloseButtonZeroFrame : CGFloat = 0
        static let mapViewBorderWidth : CGFloat = 3
    }
    
    struct RestaurantMenuViewController {
        
        static let constCloseButtonFrame : CGFloat = 30
        static let constCloseButtonZeroFrame : CGFloat = 0
        static let buttonReservationCornerRadius : CGFloat = 0.1
        static let headerHeight: CGFloat = 22.0
        static let rowHeight: CGFloat = 45.0
        static let dishesCategories: Int = 4
    }
    
    struct NewsViewController {
        
        static let constCloseButtonFrame : CGFloat = 30
        static let constCloseButtonZeroFrame : CGFloat = 0
    }
    
    struct ReservationViewController {
        
        static let estimatedSectionHeaderHeight : CGFloat = 200
        static let heightForRowAtIndexPath : CGFloat = 160
        static let heightForFooterInSection : CGFloat = 80
        static let estimatedHeightForHeaderInSection : CGFloat = 240
        static let estimatedHeightForFooterInSection : CGFloat = 80
        static let constCloseButtonFrame : CGFloat = 30
        static let constCloseButtonZeroFrame : CGFloat = 0
    }
    
    struct BookingViewController {
        
        static let constCloseButtonFrame : CGFloat = 30
        static let constCloseButtonZeroFrame : CGFloat = 0
        static let borderWidth : CGFloat = 1
        static let viewContainerCouvertsCornerRadius : CGFloat = 6
        static let viewContainerDateAndHourCornerRadius : CGFloat = 8
        static let textViewCornerRadius : CGFloat = 8
    }
    
    struct MyAccountViewController {
        
        static let borderWidth : CGFloat = 1
        static let cornerRadius : CGFloat = 6
        static let constSublayerTransform : CGFloat = 10
        static let constZeroSublayerTransform : CGFloat = 0
        static let fontSize : CGFloat = 16
        static let constCloseButtonFrame : CGFloat = 30
        static let constCloseButtonZeroFrame : CGFloat = 0
        static let constSwitchPush : CGFloat = 0.75
        static let constButtonRegister : CGFloat = 0.13
    }
    
    struct HelpViewController {
        
        static let constCloseButtonFrame : CGFloat = 30
        static let constCloseButtonZeroFrame : CGFloat = 0
    }
    
    struct LegalNoticeViewHelper {
        
        static let constCloseButtonFrame : CGFloat = 30
        static let constCloseButtonZeroFrame : CGFloat = 0
    }
    
}