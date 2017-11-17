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
    
    func dispatch(identity: String, policy: RetryPolicy, completion: BackoffDispatcherBlock)
}

class BackoffDispatcher: BackoffDispatcherType {
    
    static let shared = BackoffDispatcher()
    private(set) var dispatchers: [String: BackoffType] = [:]
    
    func dispatch(identity: String, policy: RetryPolicy, completion: BackoffDispatcherBlock) {
        
        if let backoff = dispatchers[identity] {
            backoff.reset()
            backoff.run(completion)
            return
        }
        
        let backoff = Backoff(policy: policy)
        dispatchers[identity] = backoff
        
        // Run
        backoff.run(completion)
    }
}


extension BackoffDispatcher {
    
    class func dispatchInternalTrigger(identity: String, completion: BackoffDispatcherBlock) {
        let policy = InternalTriggerRetryPolicy()
        shared.dispatch(identity, policy: policy, completion: completion)
    }
    
    class func dispatchUserInitiated(identity: String, completion: BackoffDispatcherBlock) {
        let policy = UserInitiatedRetryPolicy()
        shared.dispatch(identity, policy: policy, completion: completion)
    }
}
