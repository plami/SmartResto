//
//  AppDelegate.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 11/18/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let URL_SERVER: String = "http://1-dot-smart-messaging-server.appspot.com/rest/"
    let APPLICATION_NAME: String = "SmartResto"
    var data: NSMutableData = NSMutableData()
    var sDeviceId: String?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().translucent = true
        self.loadReservations()
        self.loadRestaurantPhoto()
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: - Push Notifications
    
    func registerForPushNotifications() {
        // Don't sign up for Push Notifications when on Simulator
        #if (arch(i386) || arch(x86_64)) && os(iOS)
        #else
            let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert,  UIUserNotificationType.Badge,  UIUserNotificationType.Sound], categories: nil)
            let application = UIApplication.sharedApplication()
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        #endif
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //        print("DEVICE TOKEN = \(deviceToken)")
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        let token = DeviceToken(pushToken: deviceTokenString)
        token.saveToken()
        
        registerOnSMSServerWithToken(token.pushToken)
        
//        print(token.pushToken)
//        print(deviceTokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        //if not SmartResto push ignore it
        guard let reservationStatus = userInfo["aps"]?["alert"] as? String else {
            return
        }
        
        if #available(iOS 9.0, *) {
            if reservationStatus.localizedStandardContainsString("Reservation") {
                if application.applicationState == .Active {
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let detail = storyboard.instantiateViewControllerWithIdentifier("ReservationViewController")
                   let navigationController = UINavigationController(rootViewController: detail)
                
                   self.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
                }
                else if application.applicationState == .Inactive {
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let detail = storyboard.instantiateViewControllerWithIdentifier("ReservationViewController")
                   let navigationController = UINavigationController(rootViewController: detail)
            
                   self.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
                }
            } else {
                if application.applicationState == .Active {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let detail = storyboard.instantiateViewControllerWithIdentifier("NewsViewController")
                    let navigationController = UINavigationController(rootViewController: detail)
                    
                    self.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
                }
                else if application.applicationState == .Inactive {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let detail = storyboard.instantiateViewControllerWithIdentifier("NewsViewController")
                    let navigationController = UINavigationController(rootViewController: detail)
                    
                    self.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
                }
            }
        } else {
            if reservationStatus.containsString("Reservation") {
                if application.applicationState == .Active {
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let detail = storyboard.instantiateViewControllerWithIdentifier("ReservationViewController")
                   let navigationController = UINavigationController(rootViewController: detail)
            
                   self.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
                 }
                else if application.applicationState == .Inactive {
                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let detail = storyboard.instantiateViewControllerWithIdentifier("ReservationViewController")
                     let navigationController = UINavigationController(rootViewController: detail)
            
                     self.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
                }
            } else {
                if application.applicationState == .Active {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let detail = storyboard.instantiateViewControllerWithIdentifier("NewsViewController")
                    let navigationController = UINavigationController(rootViewController: detail)
                    
                    self.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
                }
                    else if application.applicationState == .Inactive {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let detail = storyboard.instantiateViewControllerWithIdentifier("NewsViewController")
                    let navigationController = UINavigationController(rootViewController: detail)
                    
                    self.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
                }
            }
        }
        
        guard let articleId = userInfo["articleid"] as? String else {
            return
        }
        
        if articleId.isEmpty {
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detail = storyboard.instantiateViewControllerWithIdentifier("NewsDetailsViewController")
            let navigationController = UINavigationController(rootViewController: detail)
            
            self.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
//    {
//    "aps": {
//    "alert": "Reservation REJECTED/APPROVED",
//    "badge": 1
//    },
//    "reservationid": 13
//    }
    
//    {
//    "aps":{
//    "alert": "article title",
//    "badge": 1
//    },
//    "articleid": 32
//    }
    
    //Used for both register and unregister.
    //If the request is sent to the server without the deviceToken in the request path, then the server will unregister this device
    func registerOnSMSServerWithToken(deviceToken: String?){
    
        let serviceName: String? = "device"
        let strCurrentLocale = NSLocale.currentLocale().localeIdentifier
        let strParams: [String: AnyObject]! = ["locale" : "\(strCurrentLocale)"]
        self.sDeviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        var path: String! = String(format:"\(URL_SERVER)\(serviceName!)/\(APPLICATION_NAME)/\(self.sDeviceId!)/IOS")
//        print(path)
        if deviceToken != nil{
            path = String(format:"\(path!)/\(deviceToken!)")
        }

        let url = NSURL(string: path!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        var request = NSMutableURLRequest(URL: url!)
        
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: strParams)
        
        Alamofire.request(.POST, url!, parameters: strParams, encoding: .JSON).responseJSON { (response) -> Void in
              print(response.result.value!)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func loadReservations() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("Reservations-CI") == nil {
            let reservations = [Reservation]()
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let userData = NSKeyedArchiver.archivedDataWithRootObject(reservations)
            userDefaults.setObject(userData, forKey: "Reservations-CI")
            userDefaults.synchronize()
        }
        if userDefaults.objectForKey("Reservations-CG") == nil {
            let reservations = [Reservation]()
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let userData = NSKeyedArchiver.archivedDataWithRootObject(reservations)
            userDefaults.setObject(userData, forKey: "Reservations-CG")
            userDefaults.synchronize()
        }
    }
    
    func loadRestaurantPhoto() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("Photos") == nil {
            let photoDict: [String: AnyObject] = [
                "blobKey-CI": "",
                "blobKey-CG": ""]
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(photoDict, forKey: "Photos")
            userDefaults.synchronize()
        }
    }
}


