//
//  Image.swift
//  airgiOSTools
//
//  Created by Steven Thompson on 2017-01-17.
//  Copyright © 2017 airg. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     Get the color of a specific pixel in an image. Source: http://stackoverflow.com/a/25956283/2580195

     - parameter pos: Position of the pixel

     - returns: Color at the position
     */
    func getPixelColor(_ pos: CGPoint) -> UIColor {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
