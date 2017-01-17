//
//  Dictionary.swift
//  airG-iOS-Tools
//
//  Created by Steven Thompson on 2016-07-26.
//  Copyright © 2016 airg. All rights reserved.
//

/// Update left dictionary with keys, values from right
///
/// - parameter left:  [K:V]
/// - parameter right: [K:V]
public func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
