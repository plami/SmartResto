//
//  ReservationViewController.swift
//  SmartResto
//
//  Created by Galin Yonchev on 11/19/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit
import MessageUI
import SwiftyJSON

class ReservationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var reservations = [Reservation]()
    
    func reserveTable(sender: AnyObject) {
        let bookingView: BookingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BookingViewController") as! BookingViewController
        let navigation = UINavigationController(rootViewController: bookingView)
        self.presentViewController(navigation, animated: true, completion: nil)
    }
    
    func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedSectionHeaderHeight = 200
        tableView.estimatedSectionHeaderHeight = 200
        
        self.view.setupBackground()
        self.setupButtons()
        self.setupNavigationBar()
        
        // self.loadData()
        self.registerCustomCell()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupReservations()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setupReservations() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        self.reservations.removeAll()
        let IDs = Manager.sharedInstance.loadReservationIDs()
        if IDs.count == 0 {
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
        }
        print("COUNT: \(IDs.count)")
        for uniqueID in IDs {
            SmartRestoClientAPI.sharedInstance.getReservationByID(uniqueID, success: { (reservation) -> Void in
                self.reservations.append(reservation)
                self.reservations.sortInPlace({$0.date! < $1.date!})
                Manager.sharedInstance.reservations = self.reservations
                self.tableView.reloadData()
                if uniqueID == IDs.last {
                    self.activityIndicator.hidden = true
                    self.activityIndicator.stopAnimating()
                }
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                }, failure: { (error) -> Void in
                    AlertHelper.showNoInternetError(self)
            })
        }
    }
    
    // MARK: - Table View methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MyReservationTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("reservationCell")! as! MyReservationTableViewCell
        cell.loadData(reservations[indexPath.row])
        cell.buttonSMS.addTarget(self, action: "shareViaSMS:", forControlEvents: .TouchUpInside)
        cell.buttonSMS.tag = indexPath.row
        cell.buttonCancel.addTarget(self, action: "deleteReservation:", forControlEvents: .TouchUpInside)
        cell.buttonCancel.tag = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: HeaderView = HeaderView(size: tableView.frame.size, center: tableView.center)
        return header
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: FooterView = FooterView(size: tableView.frame.size, center: tableView.center)
        footer.btnBook.addTarget(self, action: "reserveTable:", forControlEvents: .TouchUpInside)
        return footer
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 240
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    // register custom cell
    
    func registerCustomCell() {
        let reservationCell = UINib(nibName: "MyReservationTableViewCell", bundle: nil)
        tableView.registerNib(reservationCell, forCellReuseIdentifier: "reservationCell")
    }
    
    // MARK: - Navigation
    
    func shareViaSMS(sender: AnyObject) {
        let messageComposer = MFMessageComposeViewController()
        if MFMessageComposeViewController.canSendText() {
            let reservation = Manager.sharedInstance.reservations[sender.tag]
            let messageBody = "\(Manager.sharedInstance.restaurantName), " + "\(reservation.getDateAndHour())"
            messageComposer.body = messageBody
            messageComposer.messageComposeDelegate = self
            self.presentViewController(messageComposer, animated: false, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            AlertHelper.showSendSMS(self)
        }
    }
    
    func deleteReservation(sender: AnyObject) {
        let alertAction = UIAlertAction(title: NSLocalizedString(NSLocalizedString("alert.ok", comment: ""), comment: ""), style: .Default) { (action) -> Void in
            Reservation.deleteReservation(sender.tag)
            self.setupReservations()
            self.tableView.reloadData()
        }
        AlertHelper.showDeleteReservation(self, alertAction: alertAction)
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    func setupButtons() {
//        // setup navigation close button
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
}
