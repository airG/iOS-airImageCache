//
//  Result.swift
//  airgiOSTools
//
//  Created by Steven Thompson on 2016-12-15.
//  Copyright © 2016 airg. All rights reserved.
//

import Foundation

enum Result<A> {
    case success(A)
    case failure(Error)
}
