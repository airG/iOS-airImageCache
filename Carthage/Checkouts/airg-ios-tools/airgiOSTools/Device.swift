//
//  Device.swift
//  airgiOSTools
//
//  Created by Steven Thompson on 2016-12-13.
//  Copyright © 2016 airg. All rights reserved.
//

import UIKit

extension UIDevice {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
