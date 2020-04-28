//
//  UsedVacationViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias UsedVacationViewControllerable = (UIViewController & UsedVacationViewControllerType & UsedVacationViewModelOutput)

protocol UsedVacationViewControllerType: class {
    func configure(viewModel: UsedVacationViewModelType)
}

class UsedVacationViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var navigationBar: UINavigationBar!
    
    private var viewModel: UsedVacationViewModelType!
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction private func closeButtonTapped() {
        self.viewModel.closeButtonTapped()
    }
}

// MARK: - UITableViewDataSource
extension UsedVacationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(UsedVacationCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        self.viewModel.configure(cell, for: indexPath)
        return cell
    }
}

// MARK: - UsedVacationViewModelOutput
extension UsedVacationViewController: UsedVacationViewModelOutput {
    func setUp(title: String) {
        self.tableView.dataSource = self
        self.tableView.register(UsedVacationCell.self)
        self.setUpNavigationBarItems(title: title)
    }
}

// MARK: - UsedVacationViewControllerType
extension UsedVacationViewController: UsedVacationViewControllerType {
    func configure(viewModel: UsedVacationViewModelType) {
        self.viewModel = viewModel
    }
}
extension UsedVacationViewController {
    private func setUpNavigationBarItems(title: String) {
        self.navigationBar.topItem?.title = title
    }
}
