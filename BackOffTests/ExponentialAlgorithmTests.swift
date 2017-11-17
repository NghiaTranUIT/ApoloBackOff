//
//  ExponentialAlgorithmTests.swift
//  BackOff
//
//  Created by NghiaTran on 11/17/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import XCTest
@testable import BackOff

class ExponentialAlgorithmTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExponentialOutput() {
        
        let interval = 0.5
        let algo = ExponentialAlgorithm(initialInterval: interval)
        let expected = Array(0..<20).map {
            return interval * 0.5 * (pow(2, Double($0)) - 1)
        }
        
        var ouput: [Double] = []
        for i in 0..<20 {
            let output = algo.next(at: i)
            ouput.append(output)
        }
        
        XCTAssertEqual(ouput, expected, "Exponential Algorithm doesn't work")
    }
}
