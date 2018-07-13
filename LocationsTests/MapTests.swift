//
//  MapTests.swift
//  LocationsTests
//
//  Created by AT on 10/07/2018.
//  Copyright © 2018. All rights reserved.
//

import XCTest
import MapKit
@testable import Locations

class MapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMapSelection() {
        guard RealmTestUtils.configureRealm("default") else {
            XCTAssert(false)
            return
        }
        
        let locations = LocationsManager.locations()
        XCTAssert(locations.count > 0)
        
        let controller: MapViewController = MapViewController.controller()
        _ = controller.view
        controller.locations = locations.map({$0})
        
        XCTAssert(controller.selectedAnnotations.count == 0)
        
        for location in locations {
            controller.location = location
            guard let annotation = controller.selectedAnnotations.first as? LocationAnnotation else {
                XCTAssert(false)
                return
            }
            XCTAssert(annotation.location == location)
            XCTAssert(annotation.title == location.title)
            XCTAssert(((annotation.subtitle == nil || annotation.subtitle!.isEmpty) && location.notes.isEmpty) || (annotation.subtitle == location.notes))
            XCTAssert(annotation.coordinate.latitude == location.coordinate.latitude)
            XCTAssert(annotation.coordinate.longitude == location.coordinate.longitude)
        }
    }
    
    func testOpenMapFromList() {
        guard RealmTestUtils.configureRealm("default") else {
            XCTAssert(false)
            return
        }

        let locations = LocationsManager.locations()
        XCTAssert(locations.count > 0)
        
        let controller: MainTabBarController = MainTabBarController.controller()
        _ = controller.view
        
        let listIndex = controller.viewControllers?.index(of: controller.listController)
        let mapIndex = controller.viewControllers?.index(of: controller.mapController)
        
        for location in locations {
            controller.selectedIndex = listIndex!
            controller.locationsListViewControllerDidSelectLocationOnMap(controller: controller.listController, location: location)
            XCTAssert(controller.mapController.location == location)
            XCTAssert(controller.selectedIndex == mapIndex!)
        }
    }
    
    func testMapDetailsOpen() {
        guard RealmTestUtils.configureRealm("default") else {
            XCTAssert(false)
            return
        }
        
        let locations = LocationsManager.locations()
        XCTAssert(locations.count > 0)
        
        let controller: MapContainerViewController = MapContainerViewController.controller()
        _ = controller.view
        
        for location in locations {
            controller.mapViewControllerDidSelect(controller: controller.mapViewController!, location: location)
            XCTAssert(controller.mapViewController?.location == location)
        }
    }

    func testMapDetails() {
        guard RealmTestUtils.configureRealm("default") else {
            XCTAssert(false)
            return
        }

        let locations = LocationsManager.locations()
        XCTAssert(locations.count > 0)

        let controller: MapDetailsViewController = MapDetailsViewController.controller()
        _ = controller.view

        for location in locations {
            controller.location = location
            XCTAssert(controller.titleLabel?.text == location.title)
            XCTAssert(controller.notesTextView?.text == location.notes)
            XCTAssert(controller.coordinateLabel?.text?.contains(location.latitudeString) ?? false)
            XCTAssert(controller.coordinateLabel?.text?.contains(location.longitudeString) ?? false)
        }
    }
}
