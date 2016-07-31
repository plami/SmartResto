//
//  AlertHelper.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 1/15/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import Foundation

class AlertHelper: NSObject {
    
    class func show(strTitle: String, strMessage: String, strOK: String, caller: UIViewController) {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let alertActionOK = UIAlertAction(title: strOK, style: UIAlertActionStyle.Default) { (alertAction: UIAlertAction) -> Void in
            
        }
        alert.addAction(alertActionOK)
        
        caller.presentViewController(alert, animated: true) { () -> Void in
            
        }
    }
    
    class func showNoInternetError(caller: UIViewController) {
        AlertHelper.show("", strMessage:NSLocalizedString("alert.no-internet", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showUserDataNotPopulated(caller: UIViewController) {
        AlertHelper.show("", strMessage:NSLocalizedString("alert.user", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showNotSelectedDate(caller: UIViewController) {
        AlertHelper.show("", strMessage:NSLocalizedString("alert.date", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showZeroCouverts(caller: UIViewController) {
        AlertHelper.show("", strMessage:NSLocalizedString("alert.couverts", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showSendMail(caller: UIViewController) {
        AlertHelper.show("", strMessage: NSLocalizedString("alert.mail-send", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showInputMail(caller: UIViewController) {
        AlertHelper.show("", strMessage: NSLocalizedString("alert.mail-input", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showSendSMS(caller: UIViewController) {
        AlertHelper.show("", strMessage: NSLocalizedString("alert.sms", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showGlobalNoInternet(caller: UIViewController) {
        AlertHelper.show("", strMessage: NSLocalizedString("alert.global-no-internet", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showCacheNoInternet(caller: UIViewController) {
        AlertHelper.show("", strMessage: NSLocalizedString("alert.cache-no-internet", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showDeleteReservation(caller: UIViewController, alertAction: UIAlertAction) {
        let alert = UIAlertController(title: NSLocalizedString("alert.reservation-title", comment: ""), message: NSLocalizedString("alert.reservation", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("alert.cancel", comment: ""), style: .Cancel, handler: nil)
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        caller.presentViewController(alert, animated: true) { () -> Void in
            
        }
    }
    
    class func showServerError(caller: UIViewController) {
        AlertHelper.show("", strMessage: NSLocalizedString("alert.error", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func showPastDate(caller: UIViewController) {
        AlertHelper.show("", strMessage: NSLocalizedString("alert.past-date", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func switchingPushNotificationsOn(caller: UIViewController) {
        AlertHelper.show("", strMessage: NSLocalizedString("switch.on.alert", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
    
    class func switchingPushNotificationsOff(caller: UIViewController) {
        AlertHelper.show("", strMessage: NSLocalizedString("switch.off.alert", comment: ""), strOK: NSLocalizedString("alert.ok", comment: ""), caller: caller)
    }
}