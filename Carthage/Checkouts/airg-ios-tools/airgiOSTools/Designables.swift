//
//  Designables.swift
//  airG-iOS-Tools
//
//  Created by Steven Thompson on 2016-07-26.
//  Copyright © 2016 airg. All rights reserved.
//

import UIKit

//MARK: @IBDesignable
@IBDesignable
public extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable public var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            if let layerColor = layer.borderColor {
                return UIColor(cgColor: layerColor)
            } else {
                return nil
            }
        }
    }

    @IBInspectable public var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
        }
        get {
            if let shadowColor = layer.shadowColor {
                return UIColor(cgColor: shadowColor)
            } else {
                return nil
            }
        }
    }

    @IBInspectable public var shadowRadius: CGFloat? {
        set {
            layer.shadowRadius = newValue ?? 0
        }
        get {
            return layer.shadowRadius
        }
    }
}

//MARK:-
extension UIButton {
    override open var intrinsicContentSize : CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + titleEdgeInsets.left + titleEdgeInsets.right, height: s.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
    }
}

//MARK:-
@IBDesignable
open class ExtraPaddingTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBInspectable open var horizontalPadding: CGFloat = 0 {
        didSet {
            edgeInsets = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
            invalidateIntrinsicContentSize()
        }
    }

    fileprivate var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, edgeInsets)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, edgeInsets)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, edgeInsets)
    }

    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        if let rightView = rightView {
            return CGRect(x: bounds.size.width - horizontalPadding - rightView.frame.size.width,
                          y: bounds.size.height/2 - rightView.frame.size.height/2,
                          width: rightView.frame.size.width,
                          height: rightView.frame.size.height)
        }
        return CGRect()
    }
}

//MARK:-
@IBDesignable
open class ExtraPaddingLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBInspectable open var extraHorizontalPadding: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable open var extraVerticalPadding: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override open var intrinsicContentSize : CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + 2 * extraHorizontalPadding, height: s.height + 2 * extraVerticalPadding)
    }
}

//MARK:-
@IBDesignable
open class ExtraPaddingTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBInspectable var horizontalPadding: CGFloat = 0 {
        didSet {
            textContainerInset = UIEdgeInsets(top: textContainerInset.top, left: horizontalPadding, bottom: textContainerInset.bottom, right: horizontalPadding)
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable var verticalPadding: CGFloat = 8 {
        didSet {
            textContainerInset = UIEdgeInsets(top: verticalPadding, left: textContainerInset.left, bottom: verticalPadding, right: textContainerInset.right)
            invalidateIntrinsicContentSize()
        }
    }

    override open var intrinsicContentSize : CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + 2 * horizontalPadding, height: s.height + 2 * verticalPadding)
    }
}
