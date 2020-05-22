//
//  TaskHistoryViewController.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias TaskHistoryViewControllerable = UIViewController & TaskHistoryViewControllerType & TaskHistoryViewModelOutput

protocol TaskHistoryViewControllerType: class {
    func configure(viewModel: TaskHistoryViewModelType)
}

class TaskHistoryViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: TaskHistoryViewModelType!
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        self.viewModel.closeButtonTapped()
    }
}

// MARK: - UITableViewDataSource
extension TaskHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(WorkTimeTableViewCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        self.viewModel.configure(cell, for: indexPath)
        return cell
    }
}

// MARK: - TaskHistoryViewModelOutput
extension TaskHistoryViewController: TaskHistoryViewModelOutput {
    func setUp() {
        self.setUpCloseButton()
        self.setUpTitle()
        self.setUpTableView()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.activityIndicator.set(isAnimating: isAnimating)
        self.activityIndicator.frame.size.height = isAnimating ? 120 : 0
        self.activityIndicator.layoutIfNeeded()
    }
}

// MARK: - TaskHistoryViewControllerType
extension TaskHistoryViewController: TaskHistoryViewControllerType {
    func configure(viewModel: TaskHistoryViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension TaskHistoryViewController {
    private func setUpTableView() {
        self.tableView.register(WorkTimeTableViewCell.self)
        self.tableView.dataSource = self
    }
    
    private func setUpCloseButton() {
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .closeButton,
            target: self,
            action: #selector(self.closeButtonTapped))
        self.navigationItem.setRightBarButton(closeButton, animated: false)
    }
    
    private func setUpTitle() {
        self.navigationItem.title = R.string.localizable.taskhistory_title()
    }
}
