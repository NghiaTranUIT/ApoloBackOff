//
//  BackoffState.swift
//  Backoff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

enum BackoffState {
    
    case running
    case stopped
    case failed
    case succeeded
}
