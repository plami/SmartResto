//
//  ImageViewExtend.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 1/14/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func imageFromURL(urlString: String, success: (() -> Void)?) {
        let baseURL = "http://admin.smartresto.fr/download?blobkey="
        if let url = NSURL(string: baseURL + urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                    success!()
                }
            }
        }
    }
    
    func imageFromDirectory(imageName: String) -> UIImage {
        let docDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        if let result = UIImage(contentsOfFile: String(format: "%@/%@.png", docDirectory, imageName)) {
            return result
        }
        return UIImage()
    
    }
    
}