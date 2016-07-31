//
//  MyAccountViewController.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 12/23/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var viewNotificationContainer: UIView!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var switchPush: UISwitch!
    @IBOutlet weak var buttonRegister: UIButton!
    
    @IBAction func registerUser(sender: AnyObject) {
        if self.txtEmail.text!.isEmail {
           let user = User(firstName: txtFirstName.text!, lastName: txtLastName.text!, address: txtAddress.text!, postalCode: txtPostalCode.text!, email: txtEmail.text!, phoneNumber: txtPhone.text!, pushEnabled: switchPush.on)
           user.saveUser()
           self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        } else {
            AlertHelper.showInputMail(self)
        }
    }
    
    @IBAction func switchPush(sender: AnyObject) {
        
        if self.switchPush.on {
            AlertHelper.switchingPushNotificationsOn(self)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "switchStateOn")
            let defaults = NSUserDefaults.standardUserDefaults()
            if let state = defaults.stringForKey("switchStateOn")
            {
                UIApplication.sharedApplication().registerForRemoteNotifications()
                print(state)
            }
            
        } else {
            AlertHelper.switchingPushNotificationsOff(self)
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "switchStateOff")
            let defaults = NSUserDefaults.standardUserDefaults()
            if let state = defaults.stringForKey("switchStateOff")
            {
                UIApplication.sharedApplication().unregisterForRemoteNotifications()
                print(state)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setupBackground()
        self.imageLogo.setupLogo()
        self.setupButtons()
        self.setupDelegates()
        self.setupNavigationBar()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupControls()
        registerKeyboardNotifications()
    }
    
    //Scrolling the scrollview when keyboard appears on the textFields, which are placed on the bottom of the screen
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        if CGRectContainsPoint(viewRect, txtPhone.frame.origin) {
            let scrollPoint = CGPointMake(0, txtPhone.frame.origin.y - keyboardSize.height)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    
    func hasUser() -> Bool {
        if User.loadUser() != nil {
            let currentUser: User = User.loadUser()!
            self.txtFirstName.text = currentUser.firstName
            self.txtLastName.text = currentUser.lastName
            self.txtAddress.text = currentUser.address
            self.txtPostalCode.text = currentUser.postalCode
            self.txtEmail.text = currentUser.email
            self.txtPhone.text = currentUser.phoneNumber
            // populate placeholders if some of the fields are empty
            self.populateLabels()
            switchPush.setOn(currentUser.pushEnabled, animated: false)
            return true
        } else {
            return false
        }
    }
    
    func setupDelegates() {
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtAddress.delegate = self
        self.txtPostalCode.delegate = self
        self.txtEmail.delegate = self
        self.txtPhone.delegate = self
    }

    // setup buttons - titles, colors and etc.
    func setupControls() {
        if self.hasUser() == false {
            //if there is no user, then show placeholders
            self.populateLabels()
        }
        self.lblTitle.text = NSLocalizedString("user.heading", comment: "")
        
        self.txtFirstName.layer.borderWidth = 1
        self.txtFirstName.layer.borderColor = UIColor.blackColor().CGColor
        self.txtFirstName.layer.cornerRadius = 6
        self.txtFirstName.clipsToBounds = true
        self.txtFirstName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        self.txtLastName.layer.borderWidth = 1
        self.txtLastName.layer.borderColor = UIColor.blackColor().CGColor
        self.txtLastName.layer.cornerRadius = 6
        self.txtLastName.clipsToBounds = true
        self.txtLastName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        self.txtAddress.layer.borderWidth = 1
        self.txtAddress.layer.borderColor = UIColor.blackColor().CGColor
        self.txtAddress.layer.cornerRadius = 6
        self.txtAddress.clipsToBounds = true
        self.txtAddress.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        self.txtPostalCode.layer.borderWidth = 1
        self.txtPostalCode.layer.borderColor = UIColor.blackColor().CGColor
        self.txtPostalCode.layer.cornerRadius = 6
        self.txtPostalCode.clipsToBounds = true
        self.txtPostalCode.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)

        self.txtEmail.layer.borderWidth = 1
        self.txtEmail.layer.borderColor = UIColor.blackColor().CGColor
        self.txtEmail.layer.cornerRadius = 6
        self.txtEmail.clipsToBounds = true
        self.txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        self.txtPhone.layer.borderWidth = 1
        self.txtPhone.layer.borderColor = UIColor.blackColor().CGColor
        self.txtPhone.layer.cornerRadius = 6
        self.txtPhone.clipsToBounds = true
        self.txtPhone.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        self.lblNotification.text = NSLocalizedString("user.push", comment: "")
        self.lblNotification.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 16)
        
        self.viewNotificationContainer.layer.borderWidth = 1
        self.viewNotificationContainer.layer.borderColor = UIColor.blackColor().CGColor
        self.viewNotificationContainer.layer.cornerRadius = 6
        self.viewNotificationContainer.clipsToBounds = true
        
        switchPush.transform = CGAffineTransformMakeScale(0.75, 0.75);
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    func populateLabels() {
        if self.txtFirstName.text == "" {
            self.txtFirstName.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("user.firstName", comment: ""),
                attributes:[NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-ThinItalic", size: 16)!])
        }
        if self.txtLastName.text == "" {
            self.txtLastName.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("user.lastName", comment: ""),
                attributes:[NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-ThinItalic", size: 16)!])
        }
        if self.txtAddress.text == "" {
            self.txtAddress.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("user.address", comment: ""),
                attributes:[NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-ThinItalic", size: 16)!])
        }
        if self.txtPostalCode.text == "" {
            self.txtPostalCode.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("user.code", comment: ""),
                attributes:[NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-ThinItalic", size: 16)!])
        }
        
        if self.txtEmail.text == "" {
            self.txtEmail.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("user.email", comment: ""),
                 attributes:[NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-ThinItalic", size: 16)!])
        }
        if self.txtPhone.text == "" {
            self.txtPhone.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("user.phone", comment: ""),
                attributes:[NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-ThinItalic", size: 16)!])
        }
    }
    
    func setupButtons() {
        buttonRegister.setTitle(NSLocalizedString("user.register", comment: ""), forState: UIControlState.Normal)
        buttonRegister.layer.cornerRadius = 0.13 * buttonRegister.bounds.size.width
        buttonRegister.backgroundColor = UIColor.SRLightGreen
        // setup navigation close button
        let closeImage = UIImage(named: "icon_close")
        let closeButton = UIButton(type: UIButtonType.Custom)
        closeButton.frame = CGRectMake(0, 0, 30, 30)
        closeButton.setBackgroundImage(closeImage, forState: .Normal)
        closeButton.addTarget(self, action: "goBack:", forControlEvents: .TouchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        self.navigationItem.setRightBarButtonItem(closeBarButton, animated: false)
    }
    
    func setupNavigationBar() {
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone {
            let currentText = txtPhone.text ?? ""
            let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
            return prospectiveText.containsOnlyCharactersIn("+0123456789")
        } else if textField == txtPostalCode {
            let currentText = txtPostalCode.text ?? ""
            let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
            return prospectiveText.containsOnlyCharactersIn("0123456789")
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goBack(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
