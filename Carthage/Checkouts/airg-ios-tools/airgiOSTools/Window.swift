//
//  Window.swift
//  airG-iOS-Tools
//
//  Created by Steven Thompson on 2016-09-28.
//  Copyright © 2016 airg. All rights reserved.
//

import UIKit

public extension UIWindow {
    public var topMostController: UIViewController {
        var top = self.rootViewController!
        
        while let new = top.presentedViewController {
            top = new
        }
        
        return top
    }
}
