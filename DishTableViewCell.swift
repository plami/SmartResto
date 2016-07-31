//
//  DishTableViewCell.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 2/11/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import UIKit

class DishTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDishNameAndDescription: UILabel!
    @IBOutlet weak var labelDishPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
 }
