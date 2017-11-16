//
//  LogarithmicAlgorithm.swift
//  BackOff
//
//  Created by Nghia Tran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

class LogarithmicAlgorithm: BackoffAlgorithm {
    
    private let initialInterval: Double
    
    init(initialInterval: Double) {
        self.initialInterval = initialInterval
    }
    
    func reset() {}
    
    func next(at step: Int) -> Double {
        return initialInterval * log2(Double(step))
    }
}
