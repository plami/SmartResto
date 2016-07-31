//
//  HeaderView.swift
//  SmartResto
//
//  Created by Galin Yonchev on 1/11/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UIView {
    
    let imageHeight: CGFloat = 150
    let imageWidth: CGFloat = 180
    
    let labelHeight: CGFloat = 30
    
    init(size: CGSize, center: CGPoint) {
        super.init(frame: CGRectMake(0, 0, size.width, 240))
        let centerPoint = center.x
        // add logo
        let imageLogo: UIImageView = UIImageView(frame: CGRectMake(centerPoint - imageWidth/2, 24, imageWidth, imageHeight))
        imageLogo.image = Manager.sharedInstance.getLogo()
        imageLogo.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(imageLogo)
        // add heading
        let lblHeading = UILabel(frame: CGRectMake(imageLogo.frame.origin.x, imageLogo.frame.origin.y + imageLogo.frame.size.height + 12, imageWidth, labelHeight))
        lblHeading.text = Manager.sharedInstance.restaurantName
        lblHeading.textAlignment = NSTextAlignment.Center
        lblHeading.adjustsFontSizeToFitWidth = true
        if #available(iOS 8.2, *) {
            lblHeading.font = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
        } else {
            lblHeading.font = UIFont.systemFontOfSize(20)
        }
        self.addSubview(lblHeading)
        // add line
        let viewLine = UIView(frame: CGRectMake(lblHeading.frame.origin.x, lblHeading.frame.origin.y + lblHeading.frame.size.height + 1, imageWidth, 1))
        viewLine.backgroundColor = UIColor.blackColor()
        self.addSubview(viewLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
