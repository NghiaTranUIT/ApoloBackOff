//
//  DispatcherBackoff.swift
//  Backoff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

typealias BackoffDispatcherBlock = (Int, ((Bool) -> Void)) -> ()

protocol BackoffDispatcherType {
    
    func dispatch(algorithm: BackoffAlgorithm, block: BackoffDispatcherBlock)
}

class BackoffDispatcher: BackoffDispatcherType {
    
    static let shared = BackoffDispatcher()
    private(set) var dispatchers: [BackoffType] = []
    
    func dispatch(algorithm: BackoffAlgorithm, block: BackoffDispatcherBlock) {
        
        // Create backoff
        let backoff = Backoff(algorithm: algorithm, block: block)
        dispatchers.append(backoff)
        
        // Run
        backoff.run()
    }
}


extension BackoffDispatcher {
    
    func dispatchExponential(block: BackoffDispatcherBlock) {
        let algo = FibonacciAlgorithm()
        dispatch(algo, block: block)
    }
}
