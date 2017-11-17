//
//  LogarithmicAlgorithmTests.swift
//  BackOff
//
//  Created by NghiaTran on 11/17/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import XCTest
@testable import BackOff

class LogarithmicAlgorithmTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLogarithmicOutput() {
        
        let interval = 0.5
        let algo = LogarithmicAlgorithm(initialInterval: interval)
        let expected = Array(1..<20).map {
            return interval * log2(Double($0))
        }
        
        var ouput: [Double] = []
        for i in 1..<20 {
            let output = algo.next(at: i)
            ouput.append(output)
        }
        
        XCTAssertEqual(ouput, expected, "Logarithmic Algorithm doesn't work")
    }
}
