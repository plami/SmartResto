//
//  FooterView.swift
//  SmartResto
//
//  Created by Galin Yonchev on 1/11/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import Foundation
import UIKit

class FooterView: UIView {
    
    var btnBook: UIButton
    let btnHeight: CGFloat = 34
    let btnWidth: CGFloat = 166
    
    init(size: CGSize, center: CGPoint) {
        btnBook = UIButton()
        super.init(frame: CGRectMake(0, 0, size.width, 60))
        self.addSubview(btnBook)
        self.customizeButton(btnBook)
    }
    
    private func customizeButton(button: UIButton) {
        button.frame = CGRectMake(center.x - btnWidth/2, 10, btnWidth, btnHeight)
        button.backgroundColor = UIColor.blackColor()
        button.layer.cornerRadius = 0.1 * btnWidth
        button.titleLabel?.font = UIFont.systemFontOfSize(16)
        button.setTitle(NSLocalizedString("reservations.booking", comment: ""), forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}