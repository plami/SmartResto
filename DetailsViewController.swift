//
//  DetailsViewController.swift
//  SmartResto
//
//  Created by Galin Yonchev on 11/19/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit
import QuartzCore

class DetailsViewController: UIViewController {
    
    @IBOutlet var buttonBooking: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var imageSlider: UIImageView!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let branch = Manager.sharedInstance.restaurant
    
    // MARK: - Navigation
    
    func goBack(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func bookTable(sender: AnyObject) {
        let menuView: RestaurantMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantMenuViewController") as! RestaurantMenuViewController
        let navigation = UINavigationController(rootViewController: menuView)
        self.presentViewController(navigation, animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup controls
        self.view.setupBackground()
        self.imageLogo.setupLogo()
        self.setupButtons()
        self.setupNavigationBar()
        // load and setup restaurant details
        self.getBranchImage()
        self.loadData()
        self.setupDescription()
        
    }

    override func viewDidAppear(animated: Bool) {
        self.activityIndicator.startAnimating()
    }
    
    // MARK: - Networking

    // MARK: - Controls
    
    func setupButtons() {
        labelHeading.text = Manager.sharedInstance.restaurantName
        buttonBooking.setTitle(NSLocalizedString("details.map", comment: ""), forState: UIControlState.Normal)
        buttonBooking.layer.cornerRadius = 0.1 * buttonBooking.bounds.size.width
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
    
    func loadData () {
        if branch != nil {
            self.labelDescription.text = branch!.restaurantDescription()
            self.setupDescription()
        }
    }
    
    func getBranchImage () {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if var photoDict = userDefaults.objectForKey("Photos") as? [String: AnyObject] {
            if Manager.sharedInstance.restaurantName == "Commune Image" {
                let path = fileInDocumentsDirectory("CommuneImage.png")
                if Manager.sharedInstance.restaurant?.photoURL != photoDict["blobKey-CI"] as? String && Manager.sharedInstance.restaurant?.photoURL != nil {
                    self.imageSlider.imageFromURL(Manager.sharedInstance.restaurant!.photoURL!, success: { () -> Void in
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        photoDict["blobKey-CI"] = Manager.sharedInstance.restaurant!.photoURL!
                        userDefaults.setObject(photoDict, forKey: "Photos")
                        userDefaults.synchronize()
                        self.saveImage(self.imageSlider.image!, path: path)
                    })
                } else {
                    self.imageSlider.image = self.loadImageFromPath(path)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                }
            } else if Manager.sharedInstance.restaurantName == "La Cave Garibaldi" {
                let path = fileInDocumentsDirectory("LaCaveGaribaldi.png")
                if Manager.sharedInstance.restaurant?.photoURL != photoDict["blobKey-CG"] as? String && Manager.sharedInstance.restaurant?.photoURL != nil {
                    self.imageSlider.imageFromURL(Manager.sharedInstance.restaurant!.photoURL!, success: { () -> Void in
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        photoDict["blobKey-CG"] = Manager.sharedInstance.restaurant!.photoURL!
                        userDefaults.setObject(photoDict, forKey: "Photos")
                        userDefaults.synchronize()
                        self.saveImage(self.imageSlider.image!, path: path)
                    })
                } else {
                    self.imageSlider.image = self.loadImageFromPath(path)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                }
            }
        }
    }
    
    func saveImage(image: UIImage, path: String) -> Bool {
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let data = NSData(contentsOfFile: path)
        let image = UIImage(data: data!)
        return image
    }
    
    // Documents directory
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        return documentsFolderPath
    }
    
    // File in Documents directory
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
    }
    
    func setupDescription() {
        self.labelDescription.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.labelDescription.numberOfLines = 0
        self.labelDescription.sizeToFit()
        let textSize:CGRect = labelDescription.text!.boundingRectWithSize(CGSizeMake(self.view.frame.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17.0)!], context: nil)
        self.constraintHeight.constant += textSize.size.height
    }
    
}