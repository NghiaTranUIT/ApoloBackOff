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
    
    let block: BackoffDispatcherBlock
    let algorithm: BackoffAlgorithm
    
    init(algorithm: BackoffAlgorithm, block: BackoffDispatcherBlock) {
        self.algorithm = algorithm
        self.block = block
    }
    
    func run() {
        algorithm.execute(self, completion: block)
    }
    
    func reset() {
        algorithm.reset()
    }
}
