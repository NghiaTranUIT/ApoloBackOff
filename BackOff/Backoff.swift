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
    
    private let block: BackoffDispatcherBlock
    private let algorithm: BackoffAlgorithm
    private let maxCount = 10
    private var executedBlock: dispatch_block_t?
    private(set) var state: BackoffState = .stopped
    private(set) var attempt = 0
    
    init(algorithm: BackoffAlgorithm, block: BackoffDispatcherBlock) {
        self.algorithm = algorithm
        self.block = block
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
        
        attempt += 1
        
        guard attempt < maxCount else  {
            print("Excessed max count at attemp \(attempt)")
            return;
        }
        
        // Execute
        let delay = algorithm.moveNextStep()
        print("... delay \(delay)")
        
        // Cancellabe Block
        executedBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {[unowned self] in
            self.block(self.attempt, { [unowned self] (success) in
                if success {
                    print("Success at attemp = \(self.attempt)")
                    self.reset()
                } else {
                    self.run()
                }
            })
        }
        
        // Time
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Int(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), executedBlock!)
    }
}
