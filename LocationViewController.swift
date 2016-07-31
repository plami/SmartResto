//
//  LocationViewController.swift
//  SmartResto
//
//  Created by Galin Yonchev on 11/19/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import CoreLocation
import MessageUI

class LocationViewController: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var labelHoursHeading: UILabel!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonPhoneNumber: UIButton!
    @IBOutlet weak var buttonEmail: UIButton!
    @IBOutlet weak var labelHours: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var labelHowToCome: UILabel!
    @IBOutlet weak var labelDetailsHowToCome: UILabel!

    let regionRadius: CLLocationDistance = 250
    let branch = Manager.sharedInstance.restaurant
    
    @IBAction func dialPhone(sender: AnyObject) {
        let trimmedPhonNumber = "\(branch!.phone!)".removeExcessiveSpaces
        if let url = NSURL(string: "tel://\(trimmedPhonNumber)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func sendMail(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            AlertHelper.showSendMail(self)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // setup UI
        self.view.setupBackground()
        self.imageLogo.setupLogo()
        self.setupNavigationBar()
        self.setupButtons()
        self.loadData()
        mapView.delegate = self
        let locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    // MARK: - Networking
    
    func loadData () {
        if branch != nil {
            self.labelHeading.text = branch!.name
            self.labelAddress.text = branch!.address
            self.buttonPhoneNumber.setTitle("Tel: " + "\(branch!.phone!)", forState: .Normal)
            self.buttonEmail.setTitle(branch?.email, forState: .Normal)
            self.labelHoursHeading.text = NSLocalizedString("location.subheading", comment: "")
            self.labelHowToCome.text = NSLocalizedString("location.howToCome", comment: "")
            self.labelHours.text = branch!.workingTime()
            self.labelDetailsHowToCome.text = branch!.howToCome()
            self.setupMap(branch!.latitude, longitude: branch!.longitude)
        }
    }
    
    // MARK: - Controls
    
    // Displaying Location of the Restaurant and mark it as annotation
    func setupMap(latitude: Double, longitude: Double) {
        // display location
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(initialLocation)
        // add pin annotation
        let pinRestaurant = Annotation(title: Manager.sharedInstance.restaurantName, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        self.mapView.addAnnotation(pinRestaurant)
    }

    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        if views.count > 0 {
            if let pin = views[0].annotation {
                self.mapView.selectAnnotation(pin, animated: true)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        if annotation.isKindOfClass(Annotation) {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                let btn = UIButton(type: .DetailDisclosure)
                btn.addTarget(self, action: "openMaps:", forControlEvents: .TouchUpInside)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    // open Maps app when user touches pin info button
    func openMaps(sender: AnyObject) {
        // set latitude and longitude
        let latitute:CLLocationDegrees =  branch!.latitude
        let longitute:CLLocationDegrees =  branch!.longitude
        // setup region, zoom, coordinates
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        // setup placemark
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = branch!.name
        mapItem.openInMapsWithLaunchOptions(options)
    }

    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setupNavigationBar() {
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    func setupButtons() {
        self.mapView.layer.borderColor = UIColor.blackColor().CGColor
        self.mapView.layer.borderWidth = 3
        //
        labelHours.sizeToFit()
        // setup navigation close button
        let closeImage = UIImage(named: "icon_close")
        let closeButton = UIButton(type: UIButtonType.Custom)
        closeButton.frame = CGRectMake(0, 0, 30, 30)
        closeButton.setBackgroundImage(closeImage, forState: .Normal)
        closeButton.addTarget(self, action: "goBack:", forControlEvents: .TouchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        self.navigationItem.setRightBarButtonItem(closeBarButton, animated: false)
    }
    
    // MARK: - Navigation
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: %@", error?.localizedDescription)
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        let recipient: String = buttonEmail.titleLabel!.text!
        mailComposerVC.setToRecipients([recipient])
        return mailComposerVC
    }
}