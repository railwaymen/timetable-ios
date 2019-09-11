//
//  WorkTimesViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimesViewControlleralbe = (UIViewController & WorkTimesViewControllerType & WorkTimesViewModelOutput)

protocol WorkTimesViewControllerType: class {
    func configure(viewModel: WorkTimesViewModelType)
}

class WorkTimesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var dateSelectorView: DateSelectorView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var workedHoursLabel: UILabel!
    @IBOutlet private var shouldWorkHoursLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    
    private let tableViewEstimatedRowHeight: CGFloat = 150
    private let heightForHeader: CGFloat = 50
    private let workTimeStandardCellReuseIdentifier = "WorkTimeStandardTableViewCellReuseIdentifier"
    private let workTimesTableViewHeaderIdentifier = "WorkTimesTableViewHeaderIdentifier"
    private var viewModel: WorkTimesViewModelType!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    // MARK: - Action
    @IBAction private func addNewRecordTapped(_ sender: UIButton) {
        viewModel.viewRequestForNewWorkTimeView(sourceView: sender)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: workTimeStandardCellReuseIdentifier, for: indexPath) as? WorkTimeTableViewCellalbe
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
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completion) in
            self.viewModel.viewRequestToDelete(at: indexPath) { completed in
                defer { completion(completed) }
                guard completed else { return }
                let numberOfItems = self.viewModel.numberOfRows(in: indexPath.section)
                DispatchQueue.main.async { [weak self] in
                    numberOfItems > 0
                        ? self?.tableView.deleteRows(at: [indexPath], with: .fade)
                        : self?.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                }
            }
        }
        deleteAction.backgroundColor = .crimson
        deleteAction.image = #imageLiteral(resourceName: "icon-trash")
        return deleteAction
    }
    
    private func buildDuplicateContextualAction(indexPath: IndexPath) -> UIContextualAction {
        let duplicateAction = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
            self.viewModel.viewRequestToDuplicate(sourceView: cell, at: indexPath)
            completion(true)
        }
        duplicateAction.backgroundColor = .blue
        return duplicateAction
    }
}

// MARK: - WorkTimesViewModelOutput
extension WorkTimesViewController: WorkTimesViewModelOutput {
    func setUpView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableViewEstimatedRowHeight
        
        let nib = UINib(nibName: WorkTimesTableViewHeader.className, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: workTimesTableViewHeaderIdentifier)

        dateSelectorView.delegate = self
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func updateDateSelector(currentDateString: String, previousDateString: String, nextDateString: String) {
        dateSelectorView.update(currentDateString: currentDateString, previousDateString: previousDateString, nextDateString: nextDateString)
    }
    
    func updateMatchingFullTimeLabels(workedHours: String, shouldWorkHours: String, duration: String) {
        DispatchQueue.main.async { [weak self] in
            self?.workedHoursLabel.text = workedHours + " /"
            self?.shouldWorkHoursLabel.text = shouldWorkHours + " /"
            self?.durationLabel.text = duration
        }
    }
}

// MARK: - WorkTimesViewControllerType
extension WorkTimesViewController: WorkTimesViewControllerType {
    func configure(viewModel: WorkTimesViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - DateSelectorViewDelegate
extension WorkTimesViewController: DateSelectorViewDelegate {
    func dateSelectorRequestedForPreviousDate() {
         viewModel.viewRequestForPreviousMonth()
    }
    
    func dateSelectorRequestedForNextDate() {
        viewModel.viewRequestForNextMonth()
    }
}
