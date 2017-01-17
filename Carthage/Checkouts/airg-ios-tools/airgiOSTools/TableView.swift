//
//  TableView.swift
//  airG-iOS-Tools
//
//  Created by Steven Thompson on 2016-09-28.
//  Copyright © 2016 airg. All rights reserved.
//

import UIKit

public extension UITableView {
    public func register<T: UITableViewCell>(_ type: T.Type) {
        self.register(T.Nib, forCellReuseIdentifier: T.Identifier)
    }
    
    public func dequeueCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.Identifier, for: indexPath) as! T
    }
    
    public func register<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        self.register(T.Nib, forHeaderFooterViewReuseIdentifier: T.Identifier)
    }
    
    public func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.Identifier) as! T
    }
}
