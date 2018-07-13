//
//  NotesTests.swift
//  NotesTests
//
//  Created by Michal Černý on 13/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import XCTest
@testable import Notes

class NotesTests: XCTestCase {
    
    var network : Network!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        network = Network()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPostAndGet () {
        // 1. given
        
        // 2. when
        network.postRequest(title: "testTitle")
        let response = network.getAllRequest()
        
        // 3. then
        XCTAssertGreaterThanOrEqual(response.count, 1, "There has to be at least one Note after the post.")
    }
}
