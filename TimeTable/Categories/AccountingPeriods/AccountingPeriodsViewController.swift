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
    private let minimumCellHeight: CGFloat = 63
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.viewWillDisplayCell(at: indexPath)
    }
}

// MARK: - ContainerViewControllerType
extension AccountingPeriodsViewController: ContainerViewControllerType {
    var containedViews: [UIView] {
        [self.tableView, self.errorView].compactMap { $0 }
    }
}

// MARK: - AccountingPeriodsViewModelOutput
extension AccountingPeriodsViewController: AccountingPeriodsViewModelOutput {
    func setUp() {
        self.title = R.string.localizable.accountingperiods_title()
        self.setUpTableView()
        self.viewModel.configure(self.errorView)
        self.setBottomContentInset(isHidden: false)
        self.hideAllContainedViews()
    }
    
    func showList() {
        self.showWithAnimation(view: self.tableView, duration: Constants.defaultTrasitionDuration)
    }
    
    func showErrorView() {
        self.showWithAnimation(view: self.errorView, duration: Constants.defaultTrasitionDuration)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.activityIndicator.set(isAnimating: isAnimating)
    }
    
    func setBottomContentInset(isHidden: Bool) {
        self.tableView.contentInset.bottom = isHidden ? 0 : self.minimumCellHeight
    }
    
    func getMaxCellsCountPerTableHeight() -> Int {
        self.tableView.getMaxCellsCountPerTableHeight(minimumCellHeight: self.minimumCellHeight)
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
    private func setUpTableView() {
        self.tableView.register(AccountingPeriodsCell.self)
        self.tableView.registerHeaderFooterView(AccountingPeriodsHeaderView.self)
    }
}
