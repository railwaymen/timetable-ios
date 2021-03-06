//
//  TimesheetViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias TimesheetViewControllerable = (UIViewController & TimesheetViewControllerType & TimesheetViewModelOutput)

protocol TimesheetViewControllerType: class {
    func configure(viewModel: TimesheetViewModelType)
}

class TimesheetViewController: UIViewController {
    @IBOutlet private var projectSelectionView: UIView!
    @IBOutlet private var projectColorView: AttributedButton!
    @IBOutlet private var projectNameLabel: UILabel!
    @IBOutlet private var projectButton: UIButton!
    @IBOutlet private var monthSelectionTextField: UITextField!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorView: ErrorView!
    @IBOutlet private var workedHoursLabel: UILabel!
    @IBOutlet private var accountingPeriodLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private var textFieldHeightConstraints: [NSLayoutConstraint]!
    
    private var monthPicker: MonthYearPickerView?

    private let tableViewEstimatedRowHeight: CGFloat = 150
    private let heightForHeader: CGFloat = 50
    private var viewModel: TimesheetViewModelType!
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewModel.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.viewDidDisappear()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        self.viewModel.viewShouldUpdateColors()
    }
    
    // MARK: - Actions
    @IBAction private func projectButtonTapped() {
        self.viewModel.projectButtonTapped()
    }
    
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
    
    @objc private func profileButtonTapped() {
        self.viewModel.viewRequestForProfileView()
    }
    
    @IBAction private func viewTapped() {
        self.view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource
extension TimesheetViewController: UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDelegate
extension TimesheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        self.viewModel.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let duplicateAction = self.buildDuplicateContextualAction(indexPath: indexPath)
        let historyAction = self.buildHistoryContextualAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [duplicateAction, historyAction])
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = self.buildDeleteContextualAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let header = tableView.dequeueHeaderFooterView(TimesheetSectionHeaderView.self) else { return nil }
        guard let headerViewModel = self.viewModel.viewRequestForHeaderModel(at: section, header: header) else { return nil }
        header.configure(viewModel: headerViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeader
    }
}

// MARK: - ContainerViewControllerType
extension TimesheetViewController: ContainerViewControllerType {
    var containedViews: [UIView] {
        [self.tableView, self.errorView].compactMap { $0 }
    }
}

// MARK: - TimesheetViewModelOutput
extension TimesheetViewController: TimesheetViewModelOutput {
    func setUpView() {
        self.setUpProjectView()
        self.setUpMonthPicker()
        self.setUpTableView()
        self.setUpRefreshControl()
        self.setUpNavigationItem()
        self.setUpBarButtons()
        self.setUpConstraints()
        self.tableView.updateHeaderViewHeight()
        self.viewModel.configure(self.errorView)
        self.hideAllContainedViews()
    }
    
    func updateColors() {
        self.projectSelectionView.setTextFieldAppearance()
        self.monthSelectionTextField.setTextFieldAppearance()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func updateSelectedProject(title: String, color: UIColor?, isEnabled: Bool) {
        self.projectButton.isEnabled = isEnabled
        self.projectNameLabel.text = title
        self.projectNameLabel.textColor = isEnabled ? .defaultLabel : .disabledButton
        self.projectColorView.set(isHidden: color == nil)
        self.projectColorView.backgroundColor = color
    }
    
    func updateSelectedDate(_ dateString: String, date: (month: Int, year: Int)) {
        self.monthSelectionTextField.text = dateString
        self.monthPicker?.month = date.month
        self.monthPicker?.year = date.year
    }
    
    func updateHoursLabel(workedHours: String?) {
        self.accountingPeriodLabel.set(isHidden: workedHours == nil)
        self.workedHoursLabel.text = workedHours
    }
    
    func updateAccountingPeriodLabel(text: String?) {
        self.accountingPeriodLabel.set(isHidden: text == nil)
        self.accountingPeriodLabel.text = text
    }
    
    func showTableView() {
        self.showWithAnimation(view: self.tableView, duration: Constants.slowTransitionDuration)
    }
    
    func showErrorView() {
        self.showWithAnimation(view: self.errorView, duration: Constants.slowTransitionDuration)
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.activityIndicator.set(isAnimating: isAnimating)
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
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        guard self.isViewLoaded else { return }
        let bottomInset = max(0, keyboardState.keyboardHeight - self.tableView.safeAreaInsets.bottom)
        self.tableView.contentInset.bottom = bottomInset
        self.tableView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
}

// MARK: - TimesheetViewControllerType
extension TimesheetViewController: TimesheetViewControllerType {
    func configure(viewModel: TimesheetViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension TimesheetViewController {
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
        let duplicateAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self = self,
                let cell = self.tableView.cellForRow(at: indexPath) else { return completion(false) }
            self.viewModel.viewRequestToDuplicate(sourceView: cell, at: indexPath)
            completion(true)
        }
        duplicateAction.backgroundColor = .gray
        duplicateAction.image = .duplicate
        return duplicateAction
    }
    
    private func buildHistoryContextualAction(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else { return completion(false) }
            self.viewModel.viewRequestTaskHistory(indexPath: indexPath)
            completion(true)
        }
        action.backgroundColor = .systemBlue
        action.image = .history
        return action
    }
    
    private func setUpProjectView() {
        self.projectSelectionView.setTextFieldAppearance()
    }
    
    private func setUpMonthPicker() {
        let picker = MonthYearPickerView()
        picker.onDateSelected = { [weak self] month, year in
            self?.viewModel.viewRequestForNewDate(month: month, year: year)
        }
        self.monthPicker = picker
        self.monthSelectionTextField.inputView = picker
        self.monthSelectionTextField.setTextFieldAppearance()
    }
    
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = tableViewEstimatedRowHeight
        
        self.tableView.register(WorkTimeTableViewCell.self)
        self.tableView.registerHeaderFooterView(TimesheetSectionHeaderView.self)
    }
    
    private func setUpRefreshControl() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(self.refreshControlDidActivate), for: .valueChanged)
        self.tableView.refreshControl = control
    }
    
    private func setUpNavigationItem() {
        self.title = R.string.localizable.timesheet_title()
    }
    
    private func setUpBarButtons() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let addImageView = self.buildImageView(image: .plus, tapAction: #selector(self.addNewRecordTapped))
        let profileImageView = self.buildImageView(image: .profile, tapAction: #selector(self.profileButtonTapped))
        navigationBar.setLargeTitleRightViews([addImageView, profileImageView])
    }
    
    private func setUpConstraints() {
        self.textFieldHeightConstraints.forEach {
            $0.constant = Constants.defaultTextFieldHeight
        }
    }
}
