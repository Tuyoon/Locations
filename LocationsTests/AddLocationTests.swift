//
//  AddLocationTests.swift
//  LocationsTests
//
//  Created by AT on 13/07/2018.
//  Copyright © 2018. All rights reserved.
//

import XCTest
import MapKit
@testable import Locations

class AddLocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEditing() {
        guard RealmTestUtils.configureRealm("default") else {
            XCTAssert(false)
            return
        }
        
        let locations = LocationsManager.locations()
        XCTAssert(locations.count > 0)
        
        let controller: LocationViewController = LocationViewController.controller()
        _ = controller.view
        let location = locations.first
        controller.location = location
        
        XCTAssert(controller.titleTextField.text == location?.title)
        XCTAssert(controller.latitudeTextField.text == location?.latitudeString)
        XCTAssert(controller.longitudeTextField.text == location?.longitudeString)
        XCTAssert(controller.notesTextView.text == location?.notes)
        
        XCTAssert(controller.titleTextField.isEnabled == false)
        XCTAssert(controller.latitudeTextField.isEnabled == false)
        XCTAssert(controller.longitudeTextField.isEnabled == false)
        XCTAssert(controller.notesTextView.isEditable == true)
    }
    
    func testAdding() {
        let controller: LocationViewController = LocationViewController.controller()
        _ = controller.view
        
        XCTAssert(controller.titleTextField.isEnabled == true)
        XCTAssert(controller.latitudeTextField.isEnabled == true)
        XCTAssert(controller.longitudeTextField.isEnabled == true)
        XCTAssert(controller.notesTextView.isEditable == true)
    }

}
