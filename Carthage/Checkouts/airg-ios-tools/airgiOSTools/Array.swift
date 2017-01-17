//
//  Array.swift
//  airG-iOS-Tools
//
//  Created by Steven Thompson on 2016-09-28.
//  Copyright © 2016 airg. All rights reserved.
//

public extension Array where Element: Equatable {
    /// Append iff `!self.contains(newElement)`
    ///
    /// - parameter newElement: Element to possibly append
    public mutating func appendIfUnique(_ newElement: Element) {
        if !self.contains(newElement) {
            self.append(newElement)
        }
    }
    
    /// Appends each element iff `!self.contains(newElement)`
    ///
    /// - parameter newElements: Elements to possibly append
    public mutating func appendUniqueContentsOf(_ newElements: [Element]) {
        for new in newElements {
            self.appendIfUnique(new)
        }
    }
    
    /// Returns an array of Elements not included in self
    ///
    /// - parameter newElements: Elements to compare
    ///
    /// - returns: Array of unique elements
    public func uniqueContentsOf(_ newElements: [Element]) -> [Element] {
        return newElements.filter { (element) -> Bool in
            return !self.contains(element)
        }
    }
    
    /// Returns count of unique elements
    ///
    /// - parameter newElements: Elements to compare
    ///
    /// - returns: Count of uniques
    public func uniqueCount(fromContents newElements: [Element]) -> Int {
        return uniqueContentsOf(newElements).count
    }
}

// https://gist.github.com/yamaya/972338b68020e967d96e
public extension Array {
    /// Safely subscripts an array, returning nil if index is out of bounds
    ///
    /// - Parameter index:
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }

    /// Safely subscripts an array, returning nil if index is out of bounds
    ///
    /// - Parameter index:
    subscript (safe index: Int) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }

    /// Safely subscripts an array, returning nil if index is out of bounds
    ///
    /// - Parameter index:
    func at(safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
    /// Safely subscripts an array, returning nil if index is out of bounds
    ///
    /// - Parameter index:
    func at(safe index: Int) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}
