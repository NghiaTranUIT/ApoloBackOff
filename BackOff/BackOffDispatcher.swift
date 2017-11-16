//
//  DispatcherBackOff.swift
//  BackOff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

typealias BackOffDispatcherBlock = (Int, ((Bool) -> Void)) -> ()

protocol BackOffDispatcherType {
    
    func dispatch(algorithm: BackOffAlgorithm, block: BackOffDispatcherBlock)
}

class BackOffDispatcher: BackOffDispatcherType {
    
    static let shared = BackOffDispatcher()
    private(set) var dispatchers: [BackOffType] = []
    
    func dispatch(algorithm: BackOffAlgorithm, block: BackOffDispatcherBlock) {
        
        // Create backoff
        let backoff = BackOff(algorithm: algorithm, block: block)
        dispatchers.append(backoff)
        
        // Run
        backoff.run()
    }
}


extension BackOffDispatcher {
    
    func dispatchExponential(block: BackOffDispatcherBlock) {
        let algo = ExponentialBackOffAlgorithm()
        dispatch(algo, block: block)
    }
}
