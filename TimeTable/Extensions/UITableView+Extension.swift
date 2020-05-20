//
//  UITableView+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias ReusableHeaderFooterView = ReusableCellType

extension UITableView {
    func register<T>(_ type: T.Type, bundle: Bundle? = nil) where T: ReusableCellType {
        self.register(
            UINib(nibName: type.nibName, bundle: bundle),
            forCellReuseIdentifier: type.reuseID)
    }
    
    func dequeueReusableCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T? where T: ReusableCellType {
        return self.dequeueReusableCell(withIdentifier: type.reuseID, for: indexPath) as? T
    }
    
    func registerHeaderFooterView<T>(_ type: T.Type, bundle: Bundle? = nil) where T: ReusableHeaderFooterView {
        self.register(
            UINib(nibName: type.nibName, bundle: bundle),
            forHeaderFooterViewReuseIdentifier: type.reuseID)
    }
    
    func dequeueHeaderFooterView<T>(_ type: T.Type) -> T? where T: ReusableHeaderFooterView {
        self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseID) as? T
    }
    
    func deselectAllRows(animated: Bool) {
        self.indexPathsForSelectedRows?.forEach {
            self.deselectRow(at: $0, animated: animated)
        }
    }
    
    func updateHeaderViewHeight() {
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let temporaryWidthConstraint = headerView.widthAnchor.constraint(equalToConstant: headerView.bounds.width)
        headerView.addConstraint(temporaryWidthConstraint)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(
            CGSize(width: headerView.bounds.width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        headerView.frame.size.height = headerSize.height
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraint(temporaryWidthConstraint)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}
