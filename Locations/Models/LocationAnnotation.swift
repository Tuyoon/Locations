//
//  LocationAnnotation.swift
//  Locations
//
//  Created by AT on 06/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    weak var location: Location?
    
    init(location: Location) {
        self.location = location
        self.title = location.title
        self.coordinate = location.coordinate
        super.init()
    }
}
