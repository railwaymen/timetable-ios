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
    
    private let tableViewEstimatedRowHeight: CGFloat = 150
    private let heightForHeader: CGFloat = 50
    private let workTimeStandardCellReuseIdentifier = "WorkTimeStandardTableViewCellReuseIdentifier"
    private let workTimeWithURLCellReuseIdentifier = "WorkTimeWithUrlTableViewCellReuseIdentifier"
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
        viewModel.viewRequestedForNewWorkTimeView(sourceView: sender)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellType = viewModel.viewRequestedForCellType(at: indexPath)
        var cell: WorkTimeTableViewCellalbe?
        switch cellType {
        case .standard:
            cell = tableView.dequeueReusableCell(withIdentifier: workTimeStandardCellReuseIdentifier, for: indexPath) as? WorkTimeTableViewCellalbe
        case .taskURL:
            cell = tableView.dequeueReusableCell(withIdentifier: workTimeWithURLCellReuseIdentifier, for: indexPath) as? WorkTimeTableViewCellalbe
        }
        guard let workTimeCell = cell else { return UITableViewCell() }
        guard let cellViewModel = viewModel.viewRequestedForCellModel(at: indexPath, cell: workTimeCell) else { return UITableViewCell() }
        workTimeCell.configure(viewModel: cellViewModel)
        return workTimeCell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: workTimesTableViewHeaderIdentifier) as? WorkTimesTableViewHeaderable else {
            return nil
        }
        guard let headerViewModel = viewModel.viewRequestedForHeaderModel(at: section, header: header) else { return nil }
        header.configure(viewModel: headerViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
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
         viewModel.viewRequestedForPreviousMonth()
    }
    
    func dateSelectorRequestedForNextDate() {
        viewModel.viewRequestedForNextMonth()
    }
}
