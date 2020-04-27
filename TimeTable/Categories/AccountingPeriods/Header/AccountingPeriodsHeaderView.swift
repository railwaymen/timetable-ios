//
//  AccountingPeriodsHeaderView.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

class AccountingPeriodsHeaderView: UITableViewHeaderFooterView, ReusableHeaderFooterView {
    
    // MARK: - Internal
    func configure() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGroupedBackground
        self.backgroundView = backgroundView
    }
}
