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
}

// MARK: - AccountingPeriodsViewModelOutput
extension AccountingPeriodsViewController: AccountingPeriodsViewModelOutput {
    func setUp() {
        self.title = R.string.localizable.accoutingperiods_title()
    }
}

// MARK: - AccountingPeriodsViewControllerType
extension AccountingPeriodsViewController: AccountingPeriodsViewControllerType {
    func configure(viewModel: AccountingPeriodsViewModelType) {
        self.viewModel = viewModel
    }
}
