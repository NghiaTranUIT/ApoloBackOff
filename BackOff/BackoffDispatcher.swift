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
    
    func dispatch(identity: String, maxAttemp: Int, algorithm: BackoffAlgorithm, completion: BackoffDispatcherBlock)
}

class BackoffDispatcher: BackoffDispatcherType {
    
    static let shared = BackoffDispatcher()
    private(set) var dispatchers: [String: BackoffType] = [:]
    
    func dispatch(identity: String, maxAttemp: Int, algorithm: BackoffAlgorithm, completion: BackoffDispatcherBlock) {
        
        if let backoff = dispatchers[identity] {
            backoff.reset()
            backoff.run()
            return
        }
        
        let backoff = Backoff(algorithm: algorithm, maxAttemp: maxAttemp, completion: completion)
        dispatchers[identity] = backoff
        
        // Run
        backoff.run()
    }
}


extension BackoffDispatcher {
    
    func dispatchFibonacci(identity: String, completion: BackoffDispatcherBlock) {
        let algo = FibonacciAlgorithm()
        dispatch(identity, maxAttemp: 10, algorithm: algo, completion: completion)
    }
}
