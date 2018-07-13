//
//  ValidationTests.swift
//  LocationsTests
//
//  Created by AT on 13/07/2018.
//  Copyright © 2018. All rights reserved.
//

import XCTest
@testable import Locations

class ValidationTests: XCTestCase {
    
    let validator: Validator = Validator()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInputDecimalValidation() {
        XCTAssert(validator.correctInputDecimal(text: "1..") == "1.")
        XCTAssert(validator.correctInputDecimal(text: "1.2.") == "1.2")
        XCTAssert(validator.correctInputDecimal(text: "-1-") == "-1")
        XCTAssert(validator.correctInputDecimal(text: "1--") == "1")
    }
    
    func testDecimalValidation() {
        XCTAssert(validator.correctDecimal(text: "1.") == "1")
        XCTAssert(validator.correctDecimal(text: "-") == "0")
        XCTAssert(validator.correctDecimal(text: "-.") == "0")
        XCTAssert(validator.correctDecimal(text: "-1.1-") == "-1.1")
        XCTAssert(validator.correctDecimal(text: "-1.1-1") == "-1.1")
        XCTAssert(validator.correctDecimal(text: "-1.1.") == "-1.1")
        XCTAssert(validator.correctDecimal(text: "-1.1.1") == "-1.1")
    }
    
}
