//
//  FibonacciAlgorithm.swift
//  Backoff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

final class FibonacciAlgorithm: BackoffAlgorithm {
    
    private var preValue = 0.0
    private var currentValue = 1.0
    
    func reset() {
        preValue = 1.0
        currentValue = 1.0
    }
    
    func next(at step: Int) -> Double {
        let new = currentValue + preValue
        preValue = currentValue
        currentValue = new
        return new
    }
}
