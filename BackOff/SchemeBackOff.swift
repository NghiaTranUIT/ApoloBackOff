//
//  SchemeBackoff.swift
//  BackOff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

protocol SchemeBackOffType {
    
    var maxRetryCount: Int { get }
    var timming: BackOffAlgorithm { get }
}
