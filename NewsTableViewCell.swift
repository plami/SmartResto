//
//  NewsTableViewCell.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 11/20/15.
//  Copyright © 2015 Smart Interactive. All rights reserved.
//

import UIKit
import Haneke

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var labelNews: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(color: UIColor, news: News) {
        labelDate.backgroundColor = color
        self.labelHeading.text = news.title
        self.labelDate.text = news.date
        self.labelNews.text = news.content
    }
}
