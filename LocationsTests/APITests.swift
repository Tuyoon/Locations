//
//  APITests.swift
//  LocationsTests
//
//  Created by AT on 11/07/2018.
//  Copyright © 2018. All rights reserved.
//

import XCTest
@testable import Locations

class APITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLocationsLoad() {
        API.loadLocations(onSuccess: { (response) in
            guard (response["locations"] as? [[String: AnyObject]]) != nil else {
                XCTAssert(false)
                return
            }
            guard (response["updated"] as? String) != nil else {
                XCTAssert(false)
                return
            }
            
            XCTAssert(true)
        }) { (error) in
            XCTAssert(false, "Locations load error")
        }
    }
}
