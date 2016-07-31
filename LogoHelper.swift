//
//  LogoHelper.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 1/15/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func setupLogo() {
         let image = Manager.sharedInstance.getLogo()
         self.image = image
    }
}