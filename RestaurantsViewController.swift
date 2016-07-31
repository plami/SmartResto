//
//  RestaurantsViewController.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 11/18/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantsViewController: UIViewController {

    @IBOutlet weak var burgerMenu: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageFirstRestaurant: UIImageView!
    @IBOutlet weak var imageSecondRestaurant: UIImageView!
    
    // MARK: - Navigation
    
    func chooseFirstRestaurant() {
        let mainMenu: MainMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        Manager.sharedInstance.restaurantName = Constants.RestaurantsNames.CaveGaribaldiRestaurant
        if let branch = SmartRestoClientAPI.sharedInstance.readLocalRestaurant("LaCaveGaribaldi") {
            Manager.sharedInstance.restaurant = branch
        }
        SmartRestoClientAPI.sharedInstance.getBranchDetails(Constants.RestaurantsIDs.CaveGaribaldi, success: { (branch: Restaurant) -> Void in
            Manager.sharedInstance.restaurant = branch
            mainMenu.stopIndicator()
            }) { (error) -> Void in
                if Manager.sharedInstance.restaurant != nil {
                    AlertHelper.showCacheNoInternet(self)
                } else {
                    AlertHelper.showGlobalNoInternet(self)
                }
                mainMenu.stopIndicator()
        }

        self.navigationController?.pushViewController(mainMenu, animated: true)
    }
    
    func chooseSecondRestaurant() {
        let mainMenu: MainMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        Manager.sharedInstance.restaurantName = Constants.RestaurantsNames.CommuneImageRestaurant
        if let branch = SmartRestoClientAPI.sharedInstance.readLocalRestaurant("CommuneImage") {
            Manager.sharedInstance.restaurant = branch
        }
        SmartRestoClientAPI.sharedInstance.getBranchDetails(Constants.RestaurantsIDs.CommuneImage, success: { (branch: Restaurant) -> Void in
            Manager.sharedInstance.restaurant = branch
            mainMenu.stopIndicator()
            }) { (error) -> Void in
                if Manager.sharedInstance.restaurant != nil {
                    AlertHelper.showCacheNoInternet(self)
                } else {
                    AlertHelper.showGlobalNoInternet(self)
                }
                mainMenu.stopIndicator()
        }

        self.navigationController?.pushViewController(mainMenu, animated: true)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        self.setupSlideMenu()
        self.setupControls()
        let language = NSBundle.mainBundle().preferredLocalizations.first! as String
        print(language)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Manager.sharedInstance.restaurant = nil
    }
    
    // MARK: - Controls
    
    func setupControls() {
        // set scroll view content size
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height)
        // enable image interaction
        imageFirstRestaurant.userInteractionEnabled = true
        imageSecondRestaurant.userInteractionEnabled = true
        // create and add tap gesture
        let gestureFirstRestaurant = UITapGestureRecognizer(target: self, action: "chooseFirstRestaurant")
        let gestureSecondRestaurant = UITapGestureRecognizer(target: self, action: "chooseSecondRestaurant")
        imageFirstRestaurant.addGestureRecognizer(gestureFirstRestaurant)
        imageSecondRestaurant.addGestureRecognizer(gestureSecondRestaurant)
    }
    
    // setup slide menu
    func setupSlideMenu() {
        if self.revealViewController() != nil {
            burgerMenu.target = self.revealViewController()
            burgerMenu.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
}
