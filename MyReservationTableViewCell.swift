//
//  MyReservationTableViewCell.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 1/6/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import UIKit

class MyReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewImageContainer: UIView!
    @IBOutlet weak var buttonSMS: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var labelSMS: UILabel!
    @IBOutlet weak var labelCancel: UILabel!
    @IBOutlet weak var imageClock: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var labelCouverts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setContainerBorderAndRadius()
        self.setClockBorderAndRadius()
        self.setupLabels()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setContainerBorderAndRadius() {
        viewContainer.layer.cornerRadius = 0.03 * viewContainer.frame.size.width
        viewContainer.layer.borderColor = UIColor.blackColor().CGColor
        viewContainer.layer.borderWidth = 1
    }
    
    func setClockBorderAndRadius() {
        viewImageContainer.layer.cornerRadius = 0.2 * viewImageContainer.frame.size.width
        viewImageContainer.layer.borderColor = UIColor.blackColor().CGColor
        viewImageContainer.layer.borderWidth = 1
    }
    
    func setupLabels() {
        labelSMS.text = NSLocalizedString("reservations.sms", comment: "")
        labelCancel.text = NSLocalizedString("reservations.delete", comment: "")
    }
    
    func loadData(reservation: Reservation) {
        labelCouverts.text = "\(reservation.couverts!)"
        let date: NSDate = NSDate.timestampToDate(reservation.date! / 1000)
        labelDate.text = date.getDateAndMonth()
        labelHour.text = date.getHourAndMinutes()
        self.setReservationStatus(reservation)
    }
    
    func setReservationStatus(reservation: Reservation) {
        switch (reservation.reservationType!) {
            case "WAITING":
                viewImageContainer.backgroundColor = UIColor.SRStatusWaiting
            case "VALIDATED":
                viewImageContainer.backgroundColor = UIColor.SRStatusAccepted
//                let token = DeviceToken.loadToken()
//                print(token)
//                appDelegate.registerForPushNotifications()
           case "REJECTED" :
                viewImageContainer.backgroundColor = UIColor.SRStatusRefused
//                let token = DeviceToken.loadToken()
//                print(token)
//                appDelegate.registerForPushNotifications()
        default:
            break;
        }
    }

}
