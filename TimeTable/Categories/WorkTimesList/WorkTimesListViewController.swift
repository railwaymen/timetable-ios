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

class WorkTimesListViewController: UIViewController {
    @IBOutlet private var dateSelectorView: DateSelectorView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorView: ErrorView!
    @IBOutlet private var workedHoursLabel: UILabel!
    @IBOutlet private var shouldWorkHoursLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private let tableViewEstimatedRowHeight: CGFloat = 150
    private let heightForHeader: CGFloat = 50
    private var viewModel: WorkTimesListViewModelType!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func addNewRecordTapped(_ sender: UIBarButtonItem) {
        let sourceView = sender.view ?? self.navigationController?.navigationBar ?? UIView()
        self.viewModel.viewRequestForNewWorkTimeView(sourceView: sourceView)
    }
    
    @objc private func refreshControlDidActivate() {
        self.viewModel.viewRequestToRefresh { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.refreshControl?.endRefreshing()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension WorkTimesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(WorkTimeTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        self.viewModel.configure(cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDelegate
extension WorkTimesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        self.viewModel.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
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
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: WorkTimesTableViewHeader.reuseIdentifier)
            as? WorkTimesTableViewHeaderable else {
                return nil
        }
        guard let headerViewModel = self.viewModel.viewRequestForHeaderModel(at: section, header: header) else { return nil }
        header.configure(viewModel: headerViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeader
    }
}

// MARK: - WorkTimesListViewModelOutput
extension WorkTimesListViewController: WorkTimesListViewModelOutput {
    func setUpView() {
        self.dateSelectorView.delegate = self
        self.setUpTableView()
        self.setUpRefreshControl()
        self.setUpNavigationItem()
        self.setUpActivityIndicator()
        self.viewModel.configure(errorView)
        self.tableView.set(isHidden: true)
        self.errorView.set(isHidden: true)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func updateDateSelector(currentDateString: String, previousDateString: String, nextDateString: String) {
        self.dateSelectorView.update(currentDateString: currentDateString, previousDateString: previousDateString, nextDateString: nextDateString)
    }
    
    func updateMatchingFullTimeLabels(workedHours: String, shouldWorkHours: String, duration: String) {
        self.workedHoursLabel.text = workedHours + " /"
        self.shouldWorkHoursLabel.text = shouldWorkHours + " /"
        self.durationLabel.text = duration
    }
    
    func showTableView() {
        UIView.transition(with: self.tableView, duration: 0.2, animations: { [weak self] in
            self?.tableView.set(isHidden: false)
            self?.errorView.set(isHidden: true)
        })
    }
    
    func showErrorView() {
        UIView.transition(with: self.errorView, duration: 0.2, animations: { [weak self] in
            self?.tableView.set(isHidden: true)
            self?.errorView.set(isHidden: false)
        })
    }
    
    func setActivityIndicator(isHidden: Bool) {
        isHidden ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        self.activityIndicator.set(isHidden: isHidden)
    }
    
    func insertSections(_ sections: IndexSet) {
        self.tableView.insertSections(sections, with: .fade)
    }
    
    func removeSections(_ sections: IndexSet) {
        self.tableView.deleteSections(sections, with: .fade)
    }
    
    func reloadSections(_ sections: IndexSet) {
        self.tableView.reloadSections(sections, with: .fade)
    }
    
    func performBatchUpdates(_ updates: (() -> Void)?) {
        self.tableView.performBatchUpdates(updates, completion: nil)
    }
}

// MARK: - WorkTimesListViewControllerType
extension WorkTimesListViewController: WorkTimesListViewControllerType {
    func configure(viewModel: WorkTimesListViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - DateSelectorViewDelegate
extension WorkTimesListViewController: DateSelectorViewDelegate {
    func dateSelectorRequestedForPreviousDate() {
        self.viewModel.viewRequestForPreviousMonth()
    }
    
    func dateSelectorRequestedForNextDate() {
        self.viewModel.viewRequestForNextMonth()
    }
}

// MARK: - Private
extension WorkTimesListViewController {
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
        deleteAction.backgroundColor = .deleteAction
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = tableViewEstimatedRowHeight
        
        self.tableView.register(WorkTimeTableViewCell.self)
        
        let nib = UINib(nibName: WorkTimesTableViewHeader.className, bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: WorkTimesTableViewHeader.reuseIdentifier)
    }
    
    private func setUpRefreshControl() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(self.refreshControlDidActivate), for: .valueChanged)
        self.tableView.refreshControl = control
    }
    
    private func setUpNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewRecordTapped))
        self.navigationItem.setRightBarButtonItems([addButton], animated: false)
        self.title = "tabbar.title.timesheet".localized
    }
    
    private func setUpActivityIndicator() {
        if #available(iOS 13, *) {
            self.activityIndicator.style = .large
        } else {
            self.activityIndicator.style = .gray
        }
        self.setActivityIndicator(isHidden: true)
    }
}
