//
//  NSIndexPath.swift
//  airG-iOS-Tools
//
//  Created by Steven Thompson on 2016-09-28.
//  Copyright © 2016 airg. All rights reserved.
//

import UIKit

public extension IndexPath {
    public func nextInSection() -> IndexPath {
        return IndexPath(item: self.row+1, section: self.section)
    }
    
    public func previousInSection() -> IndexPath {
        return IndexPath(item: self.row-1, section: self.section)
    }
}
