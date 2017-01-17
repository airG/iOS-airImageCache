//
//  View.swift
//  airG-iOS-Tools
//
//  Created by Steven Thompson on 2016-07-26.
//  Copyright © 2016 airg. All rights reserved.
//

import UIKit

// MARK: - Easy access to Nib and Identifier, provided you always name Identifier the same as class
public extension UIView {
    public static var Nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: Identifier, bundle: bundle)
    }
    public static var Identifier: String {
        return String(describing: self)
    }
}

public extension UIView {
    public func roundCorners(_ corners: UIRectCorner, radius: Int, borderColor: UIColor? = nil) {
        let maskLayer = CAShapeLayer()
        let roundedPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        maskLayer.path = roundedPath.cgPath
        layer.mask = maskLayer
        
        if let borderColor = borderColor {
            let borderLayer = CAShapeLayer()
            borderLayer.path = roundedPath.cgPath
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.lineWidth = 1.0
            borderLayer.fillColor = UIColor.clear.cgColor
            layer.addSublayer(borderLayer)
        }
    }
}
