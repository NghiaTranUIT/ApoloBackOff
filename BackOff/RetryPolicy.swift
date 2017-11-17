//
//  RetryPolicy.swift
//  BackOff
//
//  Created by NghiaTran on 11/17/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

protocol RetryPolicy {
    
    var maxAttempt: Int { get }
    var algorithm: BackoffAlgorithm { get }
}
