//
//  BackoffTests.swift
//  BackOff
//
//  Created by NghiaTran on 11/17/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import XCTest
@testable import BackOff

class BackoffTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBackOffExceedMaxAttemp() {
        
        let policy = SimplePolicy()
        var count = 0
        let backoff = Backoff(policy: policy)
        backoff.run { (attempt, completion) in
            count = attempt
            completion(false)
        }
        
        wait(for: 1.0)
        XCTAssertEqual(backoff.state, Backoff.State.Exceeded, "")
        XCTAssertEqual(count, policy.maxAttempt, "")
    }
    
    func testBackOffSuccess() {
        let policy = SimplePolicy()
        var count = 0
        var isSuccess = false
        let backoff = Backoff(policy: policy)
        backoff.run { (attempt, completion) in
            count = attempt
            if attempt == 4 {
                isSuccess = true
                completion(true)
            } else {
                completion(false)
            }
        }
        
        wait(for: 1.0)
        XCTAssertEqual(backoff.state, Backoff.State.Completed, "")
        XCTAssertEqual(count, 4, "")
        XCTAssertTrue(isSuccess, "")
    }
    
    func testBackOffReset() {
        let policy = SimplePolicy()
        let backoff = Backoff(policy: policy)
        backoff.run { (attempt, completion) in
            completion(false)
        }
        backoff.reset()
        
        wait(for: 1.0)
        XCTAssertEqual(backoff.state, Backoff.State.Stopped, "")
    }
}

extension XCTestCase {
    
    func wait(for duration: NSTimeInterval) {
        let waitExpectation = expectationWithDescription("Waiting")
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(duration) * NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue(), {
            waitExpectation.fulfill()
        })
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectationsWithTimeout(duration + 0.5, handler: nil)
    }
}

class ConstantAlgorithm: BackoffAlgorithm {
    func reset() {
        
    }
    
    func next(at step: Int) -> Double{
        return 0.1
    }
}

class SimplePolicy: RetryPolicy {
    
    var maxAttempt: Int {
        return 5
    }
    
    var algorithm: BackoffAlgorithm {
        return ConstantAlgorithm()
    }
}
