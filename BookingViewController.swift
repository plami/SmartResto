//
//  ReservationsListViewController.swift
//  SmartResto
//
//  Created by Galin Yonchev on 11/19/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit

class BookingViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var labelDateAndHourHeading: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var labelCouvertsHeading: UILabel!
    @IBOutlet weak var labelCouvertsNumber: UILabel!
    @IBOutlet weak var viewContainerCouverts: UIView!
    @IBOutlet weak var viewContainerDateAndHour: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonCalendar: UIButton!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var buttonBook: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var couvertsNumber: Int = 0
    var reservationDate: NSDate = NSDate()
    let language = NSBundle.mainBundle().preferredLocalizations.first! as String
    
    @IBAction func finishReservation(sender: AnyObject) {
        if self.isDatePopulated() {
            if self.isUserDataPopulated() {
                if couvertsNumber > 0 {
                    let user = User.loadUser()!
                    let token = DeviceToken.loadToken()
                    
                    self.activityIndicator.hidden = false
                    self.activityIndicator.startAnimating()
                    SmartRestoClientAPI.sharedInstance.createReservation(Manager.sharedInstance.restaurant!.id!, date: self.reservationDate.timeIntervalSince1970 * 1000, email: user.email, firstName: user.firstName, lastName: user.lastName, address: user.address, phone: user.phoneNumber, couverts: couvertsNumber, comments: textView.text, pushToken: (token?.pushToken)!,language: self.language, success: { (reservation) -> Void in
                        reservation.saveLocally()
                            self.activityIndicator.hidden = true
                            self.activityIndicator.stopAnimating()
                        
                        // if parentVC is menuVC, then dismiss all modals and present reservationsVC
                        if self.presentingViewController?.restorationIdentifier == "navMenu" {
                            self.view.window?.rootViewController?.dismissViewControllerAnimated(true, completion: {
                                NSNotificationCenter.defaultCenter().postNotificationName("SHOW_RESERVATIONS", object: nil)
                            })
                        // if not, then just dismiss current VC
                        } else {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                        }, failure: { (error) -> Void in
                            if self.reservationDate.isLessThanDate(NSDate()) {
                                AlertHelper.showPastDate(self)
                            } else {
                                 AlertHelper.showNoInternetError(self)
                            }
                            self.activityIndicator.hidden = true
                            self.activityIndicator.stopAnimating()
                    })
                } else {
                    AlertHelper.showZeroCouverts(self)
                }
            } else {
                self.showUserAlert()
            }
        } else {
            AlertHelper.showNotSelectedDate(self)
        }
    }
    
    @IBAction func openCalendar(sender: AnyObject) {
        let title = NSLocalizedString("booking.dateandhour", comment: "")
        let doneButton = NSLocalizedString("booking.register", comment: "")
        let cancelButton = NSLocalizedString("booking.cancel", comment: "")
        DatePickerDialog().show(title, doneButtonTitle: doneButton, cancelButtonTitle: cancelButton) { (date) -> Void in
            self.reservationDate = date
            self.labelDate.text = date.getDateAndMonth()
            self.labelHour.text = date.getHourAndMinutes()
        }
    }
    
    @IBAction func changeCouverts(sender: AnyObject) {
        if sender.tag == 0 {
            couvertsNumber++
        } else if sender.tag == 1 {
            if couvertsNumber > 0 {
                couvertsNumber--
            }
        }
        self.labelCouvertsNumber.text = "\(couvertsNumber)"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup control
        self.view.setupBackground()
        self.imageLogo.setupLogo()
        self.setupNavigationBar()
        self.setupButtons()
        
        self.activityIndicator.hidden = true
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        print(self.language)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Controls
    
    func setupButtons() {
        // setup navigation close button
        let closeImage = UIImage(named: "icon_close")
        let closeButton = UIButton(type: UIButtonType.Custom)
        closeButton.frame = CGRectMake(0, 0, 30, 30)
        closeButton.setBackgroundImage(closeImage, forState: .Normal)
        closeButton.addTarget(self, action: "goBack:", forControlEvents: .TouchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        self.navigationItem.setRightBarButtonItem(closeBarButton, animated: false)
        
        self.labelHeading.text = NSLocalizedString("booking.heading", comment: "")
        self.labelDateAndHourHeading.text = NSLocalizedString("booking.dateandhour", comment: "")
        self.labelDate.text = NSLocalizedString("booking.date", comment: "")
        self.labelHour.text = NSLocalizedString("booking.hour", comment: "")
        self.labelCouvertsHeading.text = NSLocalizedString("booking.couverts", comment: "")
        self.labelCouvertsNumber.text = "\(couvertsNumber)"
        
        self.viewContainerCouverts.layer.borderWidth = 1
        self.viewContainerCouverts.layer.borderColor = UIColor.blackColor().CGColor
        self.viewContainerCouverts.layer.cornerRadius = 6
        
        self.viewContainerDateAndHour.layer.borderWidth = 1
        self.viewContainerDateAndHour.layer.borderColor = UIColor.blackColor().CGColor
        self.viewContainerDateAndHour.layer.cornerRadius = 8
        
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.blackColor().CGColor
        self.textView.layer.cornerRadius = 8
        self.textView.attributedText = NSAttributedString(string: NSLocalizedString("booking.comments", comment: ""),
            attributes:[NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-ThinItalic", size: 16)!])
        self.textView.textColor = UIColor.blackColor()
        
        self.buttonBook.layer.cornerRadius = 0.13 * buttonBook.bounds.size.width
        self.buttonBook.setTitle(NSLocalizedString("booking.register", comment: ""), forState: UIControlState.Normal)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    func isUserDataPopulated() -> Bool {
        if User.loadUser() != nil {
            let user = User.loadUser()!
            if user.mainDataIsPopulated() == false {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func isDatePopulated() -> Bool {
        if labelDate.text!.isEmpty || labelHour.text!.isEmpty {
            return false
        }
        return true
    }
    
    func showUserAlert() {
        // add alert
        let message = NSLocalizedString("alert.user", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        // add action
        let actionTitle = NSLocalizedString("alert.ok", comment: "")
        let dismiss = UIAlertAction(title: actionTitle, style: .Default, handler: { (action) -> Void in
            let profileView: MyAccountViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyAccountViewController") as! MyAccountViewController
            let navigation = UINavigationController(rootViewController: profileView)
            self.presentViewController(navigation, animated: true, completion: nil)
        })
        // show alert
        alert.addAction(dismiss)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // UITextField delegate methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == NSLocalizedString("booking.comments", comment: "") {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //
    }
    
    //Scrolling the scrollview when keyboard appears on the textFields, which are placed on the bottom of the screen
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
        let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var viewRect = view.frame
        viewRect.size.height -= keyboardSize.height
//        if CGRectContainsPoint(viewRect, textView.frame.origin) {
            let scrollPoint = CGPointMake(0, textView.frame.origin.y - keyboardSize.height)
            scrollView.setContentOffset(scrollPoint, animated: true)
//        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
}
