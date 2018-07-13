//
//  AddLocationAnnotation.swift
//  Locations
//
//  Created by AT on 06/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import MapKit

class AddLocationAnnotation: NSObject, MKAnnotation {
    var title: String? = "Add New?"
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
