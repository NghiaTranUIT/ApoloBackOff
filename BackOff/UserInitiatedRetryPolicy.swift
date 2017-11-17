//
//  UserInitiatedPolicy.swift
//  BackOff
//
//  Created by NghiaTran on 11/17/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

class UserInitiatedRetryPolicy: RetryPolicy {
    
    var maxAttempt: Int {
        return 20
    }
    
    var algorithm: BackoffAlgorithm {
        return ExponentialAlgorithm()
    }
}
