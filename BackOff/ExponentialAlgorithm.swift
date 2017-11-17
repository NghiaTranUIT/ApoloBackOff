//
//  ExponentialAlgorithm.swift
//  BackOff
//
//  Created by Nghia Tran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

final class ExponentialAlgorithm: BackoffAlgorithm {
    
    private let initialInterval: Double
    
    init(initialInterval: Double = 0.5) {
        self.initialInterval = initialInterval
    }
    
    func reset() {}
    
    func next(at step: Int) -> Double {
        return initialInterval * 0.5 * (pow(2, Double(step)) - 1)
    }
}
