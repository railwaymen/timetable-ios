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

class AccountingPeriodsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorView: ErrorView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: AccountingPeriodsViewModelType!
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension AccountingPeriodsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(AccountingPeriodsCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        self.viewModel.configure(cell, for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AccountingPeriodsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        self.viewModel.configure(self.errorView)
        self.hideAllViews()
    }
    
    func showList() {
        UIView.transition(with: self.tableView, duration: 0.3, animations: { [weak self] in
            self?.tableView.set(isHidden: false)
            self?.errorView.set(isHidden: true)
        })
    }
    
    func showErrorView() {
        UIView.transition(with: self.errorView, duration: 0.3, animations: { [weak self] in
            self?.tableView.set(isHidden: true)
            self?.errorView.set(isHidden: false)
        })
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.activityIndicator.set(isAnimating: !isHidden)
    }
}

// MARK: - AccountingPeriodsViewControllerType
extension AccountingPeriodsViewController: AccountingPeriodsViewControllerType {
    func configure(viewModel: AccountingPeriodsViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension AccountingPeriodsViewController {
    private func hideAllViews() {
        self.tableView.set(isHidden: true)
        self.errorView.set(isHidden: true)
    }
}
