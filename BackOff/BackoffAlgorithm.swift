//
//  BackoffAlgorithm.swift
//  Backoff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

protocol BackoffAlgorithm {
    
    func reset()
    func next(at step: Int) -> Double
}
