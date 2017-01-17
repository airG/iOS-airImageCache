//
//  String.swift
//  airgiOSTools
//
//  Created by Steven Thompson on 2016-12-05.
//  Copyright © 2016 airg. All rights reserved.
//

import Foundation

public extension String {
    public subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
}

public extension NSString {
    public func ranges(of searchString: String, options mask: NSString.CompareOptions = []) -> [NSRange] {
        let lowercasedSelf: NSString
        if #available(iOS 9.0, *) {
            lowercasedSelf = self.localizedLowercase as NSString
        } else {
            lowercasedSelf = self.lowercased as NSString
        }
        let substring = searchString.lowercased()

        var searchRange = NSRange(location: 0, length: lowercasedSelf.length)
        var ranges: [NSRange] = []

        while (searchRange.location < lowercasedSelf.length) {
            searchRange.length = lowercasedSelf.length - searchRange.location

            let newRange = lowercasedSelf.range(of: substring, options: mask, range: searchRange)
            if newRange.location != NSNotFound {
                ranges.append(newRange)
                searchRange.location = newRange.location + newRange.length
            } else {
                break
            }
        }

        return ranges
    }
}
