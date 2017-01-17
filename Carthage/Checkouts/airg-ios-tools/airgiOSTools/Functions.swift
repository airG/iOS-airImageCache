//
//  Functions.swift
//  airgiOSTools
//
//  Created by Steven Thompson on 2016-12-16.
//  Copyright © 2016 airg. All rights reserved.
//

import UIKit

public func startNetworkIndicator() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
}

public func stopNetworkIndicator() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
}
