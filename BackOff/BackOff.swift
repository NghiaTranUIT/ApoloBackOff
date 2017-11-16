//
//  BackOff.swift
//  BackOff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

protocol BackOffType {
    
    func run()
}

class BackOff: BackOffType{
    
    let block: BackOffDispatcherBlock
    let algorithm: BackOffAlgorithm
    
    init(algorithm: BackOffAlgorithm, block: BackOffDispatcherBlock) {
        self.algorithm = algorithm
        self.block = block
    }
    
    func run() {
        algorithm.execute(self)
    }
}
