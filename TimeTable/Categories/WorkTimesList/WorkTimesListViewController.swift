//
//  WorkTimesListViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimesListViewControllerable = (UIViewController & WorkTimesListViewControllerType & WorkTimesListViewModelOutput)

protocol WorkTimesListViewControllerType: class {
    func configure(viewModel: WorkTimesListViewModelType)
}

class WorkTimesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var dateSelectorView: DateSelectorView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorView: ErrorView!
    @IBOutlet private var workedHoursLabel: UILabel!
    @IBOutlet private var shouldWorkHoursLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .crimson
        control.addTarget(self, action: #selector(refreshControlDidActivate), for: .primaryActionTriggered)
        return control
    }()
    
    private let tableViewEstimatedRowHeight: CGFloat = 150
    private let heightForHeader: CGFloat = 50
    private let workTimeStandardCellReuseIdentifier = "WorkTimeStandardTableViewCellReuseIdentifier"
    private let workTimesTableViewHeaderIdentifier = "WorkTimesTableViewHeaderIdentifier"
    private var viewModel: WorkTimesListViewModelType!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
    }
    
    // MARK: - Action
    @objc private func addNewRecordTapped(_ sender: UIBarButtonItem) {
        let sourceView = sender.view ?? navigationController?.navigationBar ?? UIView()
        viewModel.viewRequestForNewWorkTimeView(sourceView: sourceView)
    }
    
    @objc private func refreshControlDidActivate() {
        viewModel.viewRequestToRefresh { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: workTimeStandardCellReuseIdentifier, for: indexPath) as? WorkTimeTableViewCellable
        guard let workTimeCell = cell else { return UITableViewCell() }
        guard let cellViewModel = viewModel.viewRequestForCellModel(at: indexPath, cell: workTimeCell) else { return UITableViewCell() }
        workTimeCell.configure(viewModel: cellViewModel)
        return workTimeCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        viewModel.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let duplicateAction = self.buildDuplicateContextualAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [duplicateAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.buildDeleteContextualAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: workTimesTableViewHeaderIdentifier) as? WorkTimesTableViewHeaderable else {
            return nil
        }
        guard let headerViewModel = viewModel.viewRequestForHeaderModel(at: section, header: header) else { return nil }
        header.configure(viewModel: headerViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
    }
    
    // MARK: - Private
    private func buildDeleteContextualAction(indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else { return completion(false) }
            self.viewModel.viewRequestToDelete(at: indexPath) { [weak self] completed in
                defer { completion(completed) }
                guard let self = self else { return }
                guard completed else { return }
                let numberOfItems = self.viewModel.numberOfRows(in: indexPath.section)
                numberOfItems > 0
                    ? self.tableView.deleteRows(at: [indexPath], with: .fade)
                    : self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }
        }
        deleteAction.backgroundColor = .crimson
        deleteAction.image = .delete
        return deleteAction
    }
    
    private func buildDuplicateContextualAction(indexPath: IndexPath) -> UIContextualAction {
        let duplicateAction = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
            self.viewModel.viewRequestToDuplicate(sourceView: cell, at: indexPath)
            completion(true)
        }
        duplicateAction.backgroundColor = .gray
        duplicateAction.image = .duplicate
        return duplicateAction
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableViewEstimatedRowHeight
        
        let nib = UINib(nibName: WorkTimesTableViewHeader.className, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: workTimesTableViewHeaderIdentifier)

        tableView.refreshControl = refreshControl
    }
    
    private func setUpNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRecordTapped))
        navigationItem.setRightBarButtonItems([addButton], animated: false)
        title = "tabbar.title.timesheet".localized
    }
    
    private func setUpActivityIndicator() {
        if #available(iOS 13, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        setActivityIndicator(isHidden: true)
    }
}

// MARK: - WorkTimesListViewModelOutput
extension WorkTimesListViewController: WorkTimesListViewModelOutput {
    func setUpView() {
        dateSelectorView.delegate = self
        setUpTableView()
        setUpNavigationItem()
        setUpActivityIndicator()
        viewModel.configure(errorView)
        tableView.isHidden = true
        errorView.isHidden = true
    }
    
    func updateView() {
        tableView.reloadData()
    }
    
    func updateDateSelector(currentDateString: String, previousDateString: String, nextDateString: String) {
        dateSelectorView.update(currentDateString: currentDateString, previousDateString: previousDateString, nextDateString: nextDateString)
    }
    
    func updateMatchingFullTimeLabels(workedHours: String, shouldWorkHours: String, duration: String) {
        workedHoursLabel.text = workedHours + " /"
        shouldWorkHoursLabel.text = shouldWorkHours + " /"
        durationLabel.text = duration
    }
    
    func showTableView() {
        UIView.transition(with: tableView, duration: 0.2, animations: { [weak self] in
            self?.tableView.isHidden = false
            self?.errorView.isHidden = true
        })
    }
    
    func showErrorView() {
        UIView.transition(with: errorView, duration: 0.2, animations: { [weak self] in
            self?.tableView.isHidden = true
            self?.errorView.isHidden = false
        })
    }
    
    func setActivityIndicator(isHidden: Bool) {
        isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
        activityIndicator.isHidden = isHidden
    }
}

// MARK: - WorkTimesViewControllerType
extension WorkTimesListViewController: WorkTimesListViewControllerType {
    func configure(viewModel: WorkTimesListViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - DateSelectorViewDelegate
extension WorkTimesListViewController: DateSelectorViewDelegate {
    func dateSelectorRequestedForPreviousDate() {
         viewModel.viewRequestForPreviousMonth()
    }
    
    func dateSelectorRequestedForNextDate() {
        viewModel.viewRequestForNextMonth()
    }
}
