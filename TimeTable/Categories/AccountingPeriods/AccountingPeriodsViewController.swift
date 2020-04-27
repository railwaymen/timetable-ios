//
//  AccountingPeriodsViewController.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias AccountingPeriodsViewControllerable =
    UIViewController
    & AccountingPeriodsViewControllerType
    & AccountingPeriodsViewModelOutput

protocol AccountingPeriodsViewControllerType: class {
    func configure(viewModel: AccountingPeriodsViewModelType)
}

class AccountingPeriodsViewController: UITableViewController {
    private var viewModel: AccountingPeriodsViewModelType!
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(AccountingPeriodsCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        self.viewModel.configure(cell, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueHeaderFooterView(AccountingPeriodsHeaderView.self) else { return nil }
        header.configure()
        return header
    }
}

// MARK: - AccountingPeriodsViewModelOutput
extension AccountingPeriodsViewController: AccountingPeriodsViewModelOutput {
    func setUp() {
        self.title = R.string.localizable.accountingperiods_title()
        self.tableView.register(AccountingPeriodsCell.self)
        self.tableView.registerHeaderFooterView(AccountingPeriodsHeaderView.self)
    }
}

// MARK: - AccountingPeriodsViewControllerType
extension AccountingPeriodsViewController: AccountingPeriodsViewControllerType {
    func configure(viewModel: AccountingPeriodsViewModelType) {
        self.viewModel = viewModel
    }
}
