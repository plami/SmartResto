//
//  News.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 12/17/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import Foundation

class News {
    
    var title: String?
    var content: String?
    var date: String?
    var photoURL: String?
    
    init(json: [String: AnyObject]) {
        if let newsTitle = json["title"] as? String {
            self.title = newsTitle
        }
        if let newsContent = json["content"] as? String {
            self.content = newsContent
        }
        if let newsDate = json["dateCreated"] as? Double {
            self.date = NSDate.timestampToDay(newsDate)
        }
        if let photos = json["photo"] as? [String: AnyObject] {
            if let photoURL = photos["blobKey"] as? String {
                self.photoURL = photoURL
            }
        }
    }
}