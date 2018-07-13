//
//  LocationManager.swift
//  Locations
//
//  Created by AT on 06/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManagerDidUpdate(manager: LocationManager)
}

class LocationManager: NSObject {
    private static let defaultCoordinate = CLLocationCoordinate2D(latitude: -33.865, longitude: 151.209444)
    
    weak var delegate: LocationManagerDelegate?
    private var manager: CLLocationManager!
    private(set) var coordinate: CLLocationCoordinate2D = LocationManager.defaultCoordinate {
        didSet {
            informAboutUpdate()
        }
    }
    
    
    deinit {
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }
    
    convenience init(delegate: LocationManagerDelegate? ) {
        self.init()
        self.delegate = delegate
        configure()
    }
    
    private func configure() {
        manager = CLLocationManager()
        manager.delegate = self
        manager.distanceFilter = 100
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    private func informAboutUpdate() {
        delegate?.locationManagerDidUpdate(manager: self)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            coordinate = location.coordinate
        }
    }
}
