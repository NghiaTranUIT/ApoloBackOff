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
    
    func dispatch(identity: String, algorithm: BackoffAlgorithm, block: BackoffDispatcherBlock)
}

class BackoffDispatcher: BackoffDispatcherType {
    
    static let shared = BackoffDispatcher()
    private(set) var dispatchers: [String: BackoffType] = [:]
    
    func dispatch(identity: String, algorithm: BackoffAlgorithm, block: BackoffDispatcherBlock) {
        
        if let backoff = dispatchers[identity] {
            backoff.reset()
            backoff.run()
            return
        }
        
        let backoff = Backoff(algorithm: algorithm, block: block)
        dispatchers[identity] = backoff
        
        // Run
        backoff.run()
    }
}


extension BackoffDispatcher {
    
    func dispatchFibonacci(identity: String, block: BackoffDispatcherBlock) {
        let algo = FibonacciAlgorithm()
        dispatch(identity, algorithm: algo, block: block)
    }
}
