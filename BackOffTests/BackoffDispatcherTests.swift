//
//  BackoffDispatcherTests.swift
//  BackOff
//
//  Created by NghiaTran on 11/17/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import XCTest
@testable import BackOff

class BackoffDispatcherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOneEndpointExceedMaxAttempt() {
        let policy = SimplePolicy()
        let dispatcher = BackoffDispatcher()
        var count = 0
        dispatcher.dispatch("WishListSync", policy: policy) { (attempt, complete) in
            count = attempt
            complete(false)
        }
        
        wait(for: 1.0)
        XCTAssertEqual(count, policy.maxAttempt, "")
    }
    
    
    func testTwoDifferentEndpointExceedMaxAttempt() {
        let policy = SimplePolicy()
        let dispatcher = BackoffDispatcher()
        var wishListCount = 0
        var cartCount = 0
        
        dispatcher.dispatch("WishListSync", policy: policy) { (attempt, complete) in
            wishListCount = attempt
            complete(false)
        }
        dispatcher.dispatch("CartSync", policy: policy) { (attempt, complete) in
            cartCount = attempt
            complete(false)
        }
        
        wait(for: 1.0)
        XCTAssertEqual(wishListCount, policy.maxAttempt, "")
        XCTAssertEqual(cartCount, policy.maxAttempt, "")
    }
    
    func testTwoDifferentEndpointSucessWithoutConflictOther() {
        let policy = SimplePolicy()
        let dispatcher = BackoffDispatcher()
        var wishListCount = 0
        var cartCount = 0
        
        dispatcher.dispatch("WishListSync", policy: policy) { (attempt, complete) in
            wishListCount = attempt
            
            if attempt == 4 {
                complete(true)
            } else {
                complete(false)
            }
        }
        dispatcher.dispatch("CartSync", policy: policy) { (attempt, complete) in
            cartCount = attempt
            if attempt == 2 {
                complete(true)
            } else {
                complete(false)
            }
        }
        
        wait(for: 1.0)
        XCTAssertEqual(wishListCount, 4, "")
        XCTAssertEqual(cartCount, 2, "")
    }
    
    func testCallSameEndpointShouldBeResetAndStartIntermediate() {
        let policy = SimplePolicy()
        let dispatcher = BackoffDispatcher()
        var wishListCount = 0
        
        dispatch(dispatcher, policy: policy, wishListCount: &wishListCount, isFinish: false)
    
        wait(for: 2.0)
        XCTAssertEqual(wishListCount, 0, "")
    }
    
    func dispatch(dispatcher: BackoffDispatcher, policy: SimplePolicy, inout wishListCount: Int, isFinish: Bool) {
        dispatcher.dispatch("WishListSync", policy: policy) {[unowned self] (attempt, complete) in
            wishListCount = attempt
            
            if isFinish {
                complete(true)
                return
            }
            
            if attempt == 3 && !isFinish {
                self.dispatch(dispatcher, policy: policy, wishListCount: &wishListCount, isFinish: true)
            } else {
                complete(false)
            }
        }
    }
    
}
