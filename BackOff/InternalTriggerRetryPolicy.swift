//
//  InternalTriggerRetryPolicy.swift
//  BackOff
//
//  Created by NghiaTran on 11/17/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

class InternalTriggerRetryPolicy: RetryPolicy {
    
    var maxAttempt: Int {
        return 3
    }
    
    var algorithm: BackoffAlgorithm {
        return LogarithmicAlgorithm()
    }
}
