//
//  Annotation.swift
//  SmartResto
//
//  Created by Plamena Nikolova on 1/27/16.
//  Copyright © 2016 Smart Interactive. All rights reserved.
//

import MapKit
import UIKit

class Annotation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
