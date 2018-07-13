//
//  MainTabBarController.swift
//  Locations
//
//  Created by AT on 12/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    private(set) weak var listController: LocationsListViewController!
    private(set) weak var mapController: MapContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapController: MapContainerViewController = MapContainerViewController.controller()
        let listController: LocationsListViewController  = LocationsListViewController.controller()
        listController.delegate = self
        viewControllers = [mapController, listController]
        self.listController = listController
        self.mapController = mapController
        
        // Do any additional setup after loading the view.
    }
}

extension MainTabBarController: LocationsListViewControllerDelegate {
    func locationsListViewControllerDidSelectLocationOnMap(controller: LocationsListViewController, location: Location) {
        mapController.location = location
        if let index = viewControllers?.index(of: mapController) {
            selectedIndex = index
        }
    }
}
