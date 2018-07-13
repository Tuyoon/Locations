//
//  MapContainerViewController.swift
//  Locations
//
//  Created by AT on 05/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import ISHPullUp
import RealmSwift
import CoreLocation

class MapContainerViewController: ISHPullUpViewController {

    private var maximumHeight = CGFloat(200)
    private var minimumHeight = CGFloat(0)
    
    private var notificationToken: NotificationToken!
    private lazy var locations: Results<Location> = self.loadLocations()
    
    private(set) weak var mapViewController: MapViewController?
    private(set) weak var mapDetailsViewController: MapDetailsViewController?
    
    var location: Location? {
        didSet {
            mapViewController?.location = location
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateLocations()
        
        notificationToken = LocationsManager.observe { [weak self](_) in
            self?.updateLocations()
        }
    }

    private func configure() {
        mapViewController = MapViewController.controller()
        mapViewController?.delegate = self
        contentViewController = mapViewController
        
        
        mapDetailsViewController = MapDetailsViewController.controller()
        mapDetailsViewController?.delegate = self
        bottomViewController = mapDetailsViewController
        
        setBottomHidden(true, animated: false)
        
        sizingDelegate = self
        stateDelegate = self
        dimmingColor = nil
    }
    
    private func updateLocations() {
        let locations: [Location] = self.locations.map({$0})
        setBottomHidden(locations.count == 0, animated: true)
        mapViewController?.locations = locations
    }
    
    private func loadLocations() -> Results<Location> {
        return LocationsManager.locations()
    }
    
    private func showLocationViewController(location: Location) {
        let controller = showLocationViewController()
        controller.location = location
    }
    
    private func showLocationViewController(coordinate: CLLocationCoordinate2D) {
        let controller = showLocationViewController()
        controller.coordinate = coordinate
    }
    
    private func showLocationViewController() -> LocationViewController {
        let controller: LocationViewController = LocationViewController.controller()
        present(controller, animated: true, completion: nil)
        return controller
    }
}

extension MapContainerViewController: ISHPullUpSizingDelegate {
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return minimumHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        return maximumHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        if height > maximumHeight / 2 {
            return maximumHeight
        } else if height <= maximumHeight / 2 {
            return minimumHeight
        }
        return 0
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController contentVC: UIViewController) {
    }
}

extension MapContainerViewController: ISHPullUpStateDelegate {
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        if state == .expanded {
            self.location = mapDetailsViewController?.location
        }
    }
}

extension MapContainerViewController: MapViewControllerDelegate {
    func mapViewControllerDidSelect(controller: MapViewController, location: Location) {
        mapDetailsViewController?.location = location
        setState(.expanded, animated: true)
    }
    
    func mapViewControllerDidOpen(controller: MapViewController, location: Location) {
        showLocationViewController(location: location)
    }
    
    func mapViewControllerDidDeselect(controller: MapViewController) {
        setState(.collapsed, animated: true)
        location = nil
    }
    
    func mapViewControllerDidSelectAdd(controller: MapViewController, coordinate: CLLocationCoordinate2D) {
        showLocationViewController(coordinate: coordinate)
    }
}

extension MapContainerViewController: MapDetailsViewControllerDelegate {
    func mapDetailsViewControllerDidOpen(controller: MapDetailsViewController) {
        showLocationViewController(location: controller.location!)
    }
}
