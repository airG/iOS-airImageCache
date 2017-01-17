//
//  CollectionView.swift
//  airgiOSTools
//
//  Created by Steven Thompson on 2016-12-15.
//  Copyright © 2016 airg. All rights reserved.
//

import UIKit

public extension UICollectionView {
    public func register<T: UICollectionViewCell>(_ type: T.Type) {
        self.register(T.Nib, forCellWithReuseIdentifier: T.Identifier)
    }

    public func dequeueCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.Identifier, for: indexPath) as! T
    }

    public func register<T: UICollectionReusableView>(_ type: T.Type, forSupplementaryViewOfKind kind: String) {
        self.register(T.Nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.Identifier)
    }

    public func dequeueSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.Identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    /// Returns the indexPath of the one visible collection view cell. Designed for use in `scrollViewDidEndDecelerating`.
    ///
    /// **Will NOT be useful unless your itemSize == collectionView.size.**
    ///
    /// - Returns: IndexPath of the cell that is visible and centred.
    func indexPathForVisibleFullSizeCell() -> IndexPath? {
        let indexPaths = self.indexPathsForVisibleItems
        if indexPaths.count == 1, let ip = indexPaths.first {
            return ip
        } else {
            /*
             `collectionView.indexPathsForVisibleItems()` sometimes returns multiple, especially if you scroll almost all the way and then let go.
             In that case, check x position of cells for the one at 0, which is the visible cell.
             */
            for ip in self.indexPathsForVisibleItems {
                if let attributes = self.layoutAttributesForItem(at: ip) {
                    let rect = self.convert(attributes.frame, to: self.superview)
                    if rect.origin.x == 0 {
                        return ip
                    }
                }
            }
        }

        return nil
    }
}
