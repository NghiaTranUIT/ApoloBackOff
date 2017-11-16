//
//  FibonacciAlgorithm.swift
//  Backoff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

final class FibonacciAlgorithm: BackoffAlgorithm {
    
    
    private(set) var state: BackoffState = .stopped
    private(set) var attempt = 0
    private let fibonaci = [1, 1, 2, 3, 5, 8, 11, 19, 23]
    
    func stop() {
        
    }
    
    func reset() {
        
    }
    
    func execute(backOff: BackoffType, completion: BackoffDispatcherBlock) {
        
        attempt += 1
        
        if attempt >= fibonaci.count {
            print("Excessed max count at attemp \(attempt)")
            return;
        }
        
        // Execute
        let delay = fibonaci[attempt]
        print("... delay \(delay)")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Int(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            completion(self.attempt, { [unowned self] (success) in
                if success {
                    // Do nothing
                    print("Success at attemp = \(self.attempt)")
                } else {
                    self.execute(backOff, completion: completion)
                }
            })
        }
    }
}
