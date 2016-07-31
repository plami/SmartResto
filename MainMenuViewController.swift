//
//  MainMenuViewController.swift
//  SmartResto
//
//  Created by Galin Yonchev on 11/19/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var burgerMenu: UIBarButtonItem!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet var buttonDetails: UIButton!
    @IBOutlet var buttonLocation: UIButton!
    @IBOutlet var buttonRestaurantMenu: UIButton!
    @IBOutlet var buttonNews: UIButton!
    @IBOutlet var buttonBooking: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if Manager.sharedInstance.restaurant == nil {
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setupBackground()
        self.imageLogo.setupLogo()
        self.setupButtons()
        self.setupSlideMenu()
        self.setupNavigationBar()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showReservations:", name:"SHOW_RESERVATIONS", object: nil)
    }
    
    func showReservations(notification: NSNotification) {
        self.performSegueWithIdentifier("showReservations", sender: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "SHOW_RESERVATIONS", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK - Controls
    
    // setup buttons - titles, colors and etc.
    func setupButtons() {
        buttonDetails.setTitle(NSLocalizedString("main.details", comment: ""), forState: UIControlState.Normal)
        buttonLocation.setTitle(NSLocalizedString("main.location", comment: ""), forState: UIControlState.Normal)
        buttonRestaurantMenu.setTitle(NSLocalizedString("main.menu", comment: ""), forState: UIControlState.Normal)
        buttonNews.setTitle(NSLocalizedString("main.news", comment: ""), forState: UIControlState.Normal)
        buttonBooking.setTitle(NSLocalizedString("main.reservation", comment: ""), forState: UIControlState.Normal)
    }
    
    // Setup slide menu
    func setupSlideMenu() {
        if self.revealViewController() != nil {
            burgerMenu.target = self.revealViewController()
            burgerMenu.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func setupNavigationBar() {
        //hiding the back button in the navigation bar
        self.navigationItem.setHidesBackButton(true, animated:true)
        if Manager.sharedInstance.restaurant == nil {
            self.startIndicator()
        } else {
            self.stopIndicator()
        }
    }
    
    func stopIndicator() {
        if self.activityIndicator != nil {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
        }
    }
    
    func startIndicator() {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
    }
}
