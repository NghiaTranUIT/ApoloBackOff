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
    func run()
}

class Backoff: BackoffType {
    
    private let completion: BackoffDispatcherBlock
    private let algorithm: BackoffAlgorithm
    private var executedBlock: dispatch_block_t?
    
    private let maxAttemp: Int
    private var attempt = 0
    
    init(algorithm: BackoffAlgorithm, maxAttemp: Int, completion: BackoffDispatcherBlock) {
        self.maxAttemp = maxAttemp
        self.algorithm = algorithm
        self.completion = completion
    }
    
    func reset() {
        if let executedBlock = executedBlock {
            print("--- Reset block")
            dispatch_block_cancel(executedBlock)
        }
        attempt = 0
        algorithm.reset()
    }
    
    func run() {
        guard attempt <= maxAttemp else  {
            print("Excessed max count at attemp \(attempt)")
            return;
        }
        
        // Generate next step
        attempt += 1
        let delay = algorithm.next(at: attempt)
        print("... delay \(delay)")
        
        // Cancellabe Block
        executedBlock = createBlock()
        
        // Time
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(delay) * NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue(), executedBlock!)
    }
}

extension Backoff {
    
    private func createBlock() -> dispatch_block_t {
        return dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {[unowned self] in
            self.completion(self.attempt, { [unowned self] (success) in
                if success {
                    print("Success at attemp = \(self.attempt)")
                    self.reset()
                } else {
                    self.run()
                }
            })
        }
    }
}
