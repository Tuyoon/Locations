//
//  LocationsRealmTests.swift
//  LocationsTests
//
//  Created by AT on 10/07/2018.
//  Copyright © 2018. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Locations

class LocationsRealmTests: XCTestCase {
    
    private let expectationChange = XCTestExpectation(description: "Locations change")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        RealmTestUtils.clear()
    }
    
    func testLocationsLoading() {
        guard RealmTestUtils.configureRealm("empty") else {
            XCTAssert(false)
            return
        }
        
        let locations = LocationsManager.locations()
        XCTAssert(locations.count == 0)
        
        _ = LocationsManager.observe {(change) in
            switch change {
            case .update:
                self.expectationChange.fulfill()
            default:
                break
            }
        }
        LocationsManager.loadLocations()
        wait(for: [expectationChange], timeout: 10.0)
        
        XCTAssert(locations.count > 0)
    }
    
    func testLocationsUpdate() {
        guard RealmTestUtils.configureRealm("update") else {
            XCTAssert(false)
            return
        }
        
        let locations = LocationsManager.locations()
        XCTAssert(locations.count > 0)
        
        for location in locations {
            XCTAssert(location.title.count == 0)
            XCTAssert(location.latitude == 0)
            XCTAssert(location.longitude == 0)
        }
        
        _ = LocationsManager.observe {(change) in
            switch change {
            case .update:
                self.expectationChange.fulfill()
            default:
                break
            }
        }
        LocationsManager.loadLocations()
        wait(for: [expectationChange], timeout: 10.0)
        XCTAssert(locations.count > 0)
        
        for location in locations {
            XCTAssert(location.title == location.id)
            XCTAssert(location.latitude != 0)
            XCTAssert(location.longitude != 0)
        }
        
    }
}
