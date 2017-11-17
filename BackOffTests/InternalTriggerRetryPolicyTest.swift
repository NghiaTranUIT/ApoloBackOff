//
//  InternalTriggerRetryPolicyTest.swift
//  BackOff
//
//  Created by NghiaTran on 11/17/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import XCTest
@testable import BackOff

class InternalTriggerRetryPolicyTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInternalTriggerPolicyMatchTicketRequirement() {
        
        let policy = InternalTriggerRetryPolicy()
        
        XCTAssertEqual(policy.maxAttempt, 3, "InternalTriggerRetryPolicy maxAttempt should equal 3")
        XCTAssertTrue(policy.algorithm is LogarithmicAlgorithm, "InternalTriggerRetryPolicy should have Logarithmic Algo")
    }
}
