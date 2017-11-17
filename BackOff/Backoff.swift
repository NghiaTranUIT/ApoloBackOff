//
//  Backoff.swift
//  Backoff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

protocol BackoffType {
    
    func reset()
    func run(completion: BackoffDispatcherBlock)
}

final class Backoff: BackoffType {

    enum State {
        case Running
        case Stopped
        case Exceeded
        case Completed
    }
    
    private let algorithm: BackoffAlgorithm
    private var executedBlock: dispatch_block_t?
    
    private(set) var state = Backoff.State.Stopped
    private let maxAttempt: Int
    private var attempt = 0
    
    init(policy: RetryPolicy) {
        self.maxAttempt = policy.maxAttempt
        self.algorithm = policy.algorithm
    }
    
    func reset() {
        if let executedBlock = executedBlock {
            print("--- Reset block")
            dispatch_block_cancel(executedBlock)
        }
        state = .Stopped
        attempt = 0
        algorithm.reset()
    }
    
    func run(completion: BackoffDispatcherBlock) {
        self.attempt += 1
        
        guard attempt <= maxAttempt else  {
            reset()
            state = .Exceeded
            print("Excessed max count at attemp \(attempt)")
            return;
        }
        
        // Generate next step
        let delay = algorithm.next(at: attempt)
        print("... delay \(delay)")
        
        // Cancellabe Block
        executedBlock = createBlock(completion)
    
        // Time
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(delay) * NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue(), executedBlock!)
        
        state = .Running
    }
}

extension Backoff {
    
    private func createBlock(completion: BackoffDispatcherBlock) -> dispatch_block_t {
        return dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {[unowned self] in
            completion(self.attempt, { [unowned self] (success) in
                if success {
                    print("Success at attemp = \(self.attempt)")
                    self.reset()
                    self.state = .Completed
                } else {
                    self.run(completion)
                }
            })
        }
    }
}
