//
//  TimesheetViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import UIKit

protocol TimesheetViewModelOutput: class {
    func setUpView()
    func updateColors()
    func reloadData()
    func updateSelectedProject(title: String, color: UIColor?)
    func updateSelectedDate(_ dateString: String, date: (month: Int, year: Int))
    func updateHoursLabel(workedHours: String?)
    func updateAccountingPeriodLabel(text: String?)
    func setActivityIndicator(isHidden: Bool)
    func showTableView()
    func showErrorView()
    func insertSections(_ sections: IndexSet)
    func removeSections(_ sections: IndexSet)
    func reloadSections(_ sections: IndexSet)
    func performBatchUpdates(_ updates: (() -> Void)?)
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState)
}

protocol TimesheetViewModelType: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidLayoutSubviews()
    func viewDidDisappear()
    func viewShouldUpdateColors()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func configure(_ view: ErrorViewable)
    func projectButtonTapped()
    func viewRequestForNewDate(month: Int, year: Int)
    func viewRequestForCellType(at index: IndexPath) -> TimesheetViewModel.CellType
    func configure(_ cell: WorkTimeTableViewCellable, for indexPath: IndexPath)
    func viewRequestForHeaderModel(
        at section: Int,
        header: TimesheetSectionHeaderViewModelOutput) -> TimesheetSectionHeaderViewModelType?
    func viewRequestToDuplicate(sourceView: UITableViewCell, at indexPath: IndexPath)
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void)
    func viewRequestTaskHistory(indexPath: IndexPath)
    func viewRequestForNewWorkTimeView(sourceView: UIView)
    func viewRequestedForEditEntry(sourceView: UITableViewCell, at indexPath: IndexPath)
    func viewRequestToRefresh(completion: @escaping () -> Void)
    func viewRequestForProfileView()
}

class TimesheetViewModel: KeyboardManagerObserverable {
    private weak var userInterface: TimesheetViewModelOutput?
    private weak var coordinator: TimesheetCoordinatorDelegate?
    private let contentProvider: TimesheetContentProviderType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private let messagePresenter: MessagePresenterType?
    private let keyboardManager: KeyboardManagerable
    private let smoothLoadingManager: SmoothLoadingManagerType
    
    private var selectedMonth: MonthPeriod = MonthPeriod() {
        didSet {
            guard self.selectedMonth != oldValue else { return }
            self.updateDateSelectorView()
            self.fetchWorkTimesData()
        }
    }
    
    private var state: State?
    private var didViewLayoutSubviews: Bool = false {
        didSet {
            guard self.didViewLayoutSubviews else { return }
            self.userInterface?.reloadData()
        }
    }
    
    private var projects: [SimpleProjectRecordDecoder] = []
    private var selectedProject: SimpleProjectRecordDecoder = .allProjects {
        didSet {
            self.filterWorkTimesBySelectedProject()
            self.updateUI()
        }
    }
    
    private var allDailyWorkTimes: [DailyWorkTime] = [] {
        didSet {
            self.filterWorkTimesBySelectedProject()
        }
    }
    
    private var visibleDailyWorkTimes: [DailyWorkTime] = [] {
        didSet {
            guard self.didViewLayoutSubviews else { return }
            let (insertedSections, removedSections) = self.getSectionsDiff(oldValue: oldValue)
            let updatedSections = self.getUpdatedSections(oldValue: oldValue)
            self.userInterface?.performBatchUpdates { [weak userInterface] in
                userInterface?.removeSections(removedSections)
                userInterface?.insertSections(insertedSections)
                userInterface?.reloadSections(updatedSections)
            }
        }
    }
    
    private weak var errorViewModel: ErrorViewModelParentType?
    
    // MARK: - Initialization
    init(
        userInterface: TimesheetViewModelOutput,
        coordinator: TimesheetCoordinatorDelegate?,
        contentProvider: TimesheetContentProviderType,
        errorHandler: ErrorHandlerType,
        calendar: CalendarType = Calendar.autoupdatingCurrent,
        messagePresenter: MessagePresenterType?,
        keyboardManager: KeyboardManagerable
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.messagePresenter = messagePresenter
        self.keyboardManager = keyboardManager
        self.smoothLoadingManager = SmoothLoadingManager { [weak userInterface] isAnimating in
            userInterface?.setActivityIndicator(isHidden: !isAnimating)
        }
    }
}

// MARK: - Structures
extension TimesheetViewModel {
    struct RequiredData {
        let dailyWorkTimes: [DailyWorkTime]
        let matchingFulltime: MatchingFullTimeDecoder
        let simpleProjects: [SimpleProjectRecordDecoder]
    }
    
    enum CellType {
        case standard
        case taskURL
    }
    
    private struct MonthPeriod: Equatable {
        let month: Int
        let year: Int
        
        var date: Date? {
            let calendar = Calendar(identifier: .gregorian)
            return calendar.date(bySettingYear: self.year, month: self.month, of: Date())
        }
        
        // MARK: - Initialization
        init(date: Date = Date()) {
            let calendar = Calendar(identifier: .gregorian)
            self.month = calendar.component(.month, from: date)
            self.year = calendar.component(.year, from: date)
        }
        
        init(month: Int, year: Int) {
            self.month = month
            self.year = year
        }
    }
    
    private enum State {
        case fetching
        case fetched
        case error
    }
}
 
// MARK: - TimesheetViewModelType
extension TimesheetViewModel: TimesheetViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUpView()
    }
    
    func viewWillAppear() {
        self.keyboardManager.setKeyboardStateChangeHandler(for: self) { [weak userInterface] state in
            userInterface?.keyboardStateDidChange(to: state)
        }
        guard self.state == .none else { return }
        self.updateUI()
        self.fetchRequiredData()
    }
    
    func viewDidLayoutSubviews() {
        guard !self.didViewLayoutSubviews else { return }
        self.didViewLayoutSubviews = true
    }
    
    func viewDidDisappear() {
        self.keyboardManager.removeHandler(for: self)
    }
    
    func viewShouldUpdateColors() {
        self.userInterface?.updateColors()
        self.userInterface?.reloadData()
    }
    
    func numberOfSections() -> Int {
        self.visibleDailyWorkTimes.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        self.visibleDailyWorkTimes[safeIndex: section]?.workTimes.count ?? 0
    }
    
    func configure(_ view: ErrorViewable) {
        let viewModel = ErrorViewModel(userInterface: view, localizedError: UIError.genericError) { [weak self] in
            guard let self = self else { return }
            self.fetchRequiredData()
        }
        view.configure(viewModel: viewModel)
        self.errorViewModel = viewModel
    }
    
    func projectButtonTapped() {
        guard !self.projects.isEmpty else { return }
        let projects: [SimpleProjectRecordDecoder] = [.allProjects] + self.projects
        self.coordinator?.timesheetRequestedForProjectPicker(projects: projects) { [weak self] selectedProject in
            guard let selectedProject = selectedProject else { return }
            self?.selectedProject = selectedProject
        }
    }
    
    func viewRequestForNewDate(month: Int, year: Int) {
        self.selectedMonth = MonthPeriod(month: month, year: year)
    }
    
    func viewRequestForCellType(at index: IndexPath) -> TimesheetViewModel.CellType {
        guard let workTime = self.workTime(for: index) else { return .standard }
        return workTime.taskPreview == nil ? .standard : .taskURL
    }
    
    func configure(_ cell: WorkTimeTableViewCellable, for indexPath: IndexPath) {
        guard let workTime = self.workTime(for: indexPath) else { return }
        let viewModel = WorkTimeTableViewCellModel(
            userInterface: cell,
            parent: self,
            errorHandler: self.errorHandler,
            workTime: WorkTimeDisplayed(workTime: workTime))
        cell.configure(viewModel: viewModel)
    }
    
    func viewRequestForHeaderModel(
        at section: Int,
        header: TimesheetSectionHeaderViewModelOutput
    ) -> TimesheetSectionHeaderViewModelType? {
        guard let dailyWorkTime = self.visibleDailyWorkTimes[safeIndex: section] else { return nil }
        return TimesheetSectionHeaderViewModel(userInterface: header, dailyWorkTime: dailyWorkTime)
    }
    
    func viewRequestToDuplicate(sourceView: UITableViewCell, at indexPath: IndexPath) {
        guard let task = self.createTaskForm(for: indexPath) else { return }
        let lastTask = self.createTaskForm(for: IndexPath(row: 0, section: 0))
        self.coordinator?.timesheetRequestedForWorkTimeView(
            sourceView: sourceView,
            flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask)) { [weak self] isTaskChanged in
                guard let self = self, isTaskChanged else { return }
                self.fetchWorkTimesData()
            }
    }
    
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void) {
        guard let workTime = self.workTime(for: index) else { return completion(false) }
        let cancelButtonConfig = ButtonConfig(
            title: R.string.localizable.timesheet_delete_alert_cancel(),
            style: .cancel,
            action: { completion(false) })
        let confirmButtonConfig = ButtonConfig(
            title: R.string.localizable.timesheet_delete_alert_confirm(),
            style: .destructive,
            action: { [weak self] in
                guard let self = self else { return completion(false) }
                self.contentProvider.delete(workTime: workTime) { [weak self] result in
                    guard let self = self else { return completion(false) }
                    switch result {
                    case .success:
                        self.removeDailyWorkTime(at: index, workTime: workTime, completion: completion)
                        self.updateWorkedHoursLabel()
                    case let .failure(error):
                        self.errorHandler.throwing(error: error)
                        completion(false)
                    }
                }
        })
        self.messagePresenter?.requestDecision(
            title: R.string.localizable.timesheet_delete_alert_title(),
            message: R.string.localizable.timesheet_delete_alert_message(),
            cancelButtonConfig: cancelButtonConfig,
            confirmButtonConfig: confirmButtonConfig)
    }
    
    func viewRequestTaskHistory(indexPath: IndexPath) {
        guard let taskForm = self.createTaskForm(for: indexPath) else { return }
        self.coordinator?.timesheetRequestedForTaskHistory(taskForm: taskForm)
    }
    
    func viewRequestForNewWorkTimeView(sourceView: UIView) {
        let lastTask = self.createTaskForm(for: IndexPath(row: 0, section: 0))
        self.coordinator?.timesheetRequestedForWorkTimeView(
            sourceView: sourceView,
            flowType: .newEntry(lastTask: lastTask)) { [weak self] isTaskChanged in
                guard let self = self, isTaskChanged else { return }
                self.fetchWorkTimesData()
        }
    }
    
    func viewRequestedForEditEntry(sourceView: UITableViewCell, at indexPath: IndexPath) {
        guard let task = self.createTaskForm(for: indexPath) else { return }
        self.coordinator?.timesheetRequestedForWorkTimeView(
            sourceView: sourceView,
            flowType: .editEntry(editedTask: task)) { [weak self] isTaskChanged in
                guard let self = self, isTaskChanged else { return }
                self.fetchWorkTimesData()
        }
    }
    
    func viewRequestToRefresh(completion: @escaping () -> Void) {
        guard let date = self.selectedMonth.date.unwrapped(using: self.errorHandler) else { return }
        self.contentProvider.fetchRequiredData(for: date) { [weak self] result in
            defer { completion() }
            switch result {
            case let .success(requiredData):
                self?.handleFetchSuccess(requiredData: requiredData)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    func viewRequestForProfileView() {
        self.coordinator?.timesheetRequestedForProfileView()
    }
}

// MARK: - WorkTimeTableViewCellViewModelParentType
extension TimesheetViewModel: WorkTimeTableViewCellModelParentType {
    func openTask(for workTime: WorkTimeDisplayed) {
        guard let task = workTime.task, let url = URL(string: task) else { return }
        self.coordinator?.timesheetRequestedForSafari(url: url)
    }
}

// MARK: - Private
extension TimesheetViewModel {
    private func createTaskForm(for indexPath: IndexPath) -> TaskForm? {
        guard let dailyWorkTime = self.dailyWorkTime(for: indexPath) else { return nil }
        guard let workTime = self.workTime(for: indexPath) else { return nil }
        return TaskForm(
            workTimeID: workTime.id,
            project: workTime.project,
            body: workTime.body ?? "",
            urlString: workTime.task ?? "",
            day: dailyWorkTime.day,
            startsAt: workTime.startsAt,
            endsAt: workTime.endsAt,
            tag: workTime.tag)
    }
    
    private func removeDailyWorkTime(at indexPath: IndexPath, workTime: WorkTimeDecoder, completion: @escaping (Bool) -> Void) {
        guard let dailyWorkTime = self.dailyWorkTime(for: indexPath),
            let userInterface = self.userInterface else { return completion(false) }
        let newDailyWorkTime = dailyWorkTime.removing(workTime: workTime)
        userInterface.performBatchUpdates { [weak self] in
            completion(newDailyWorkTime.workTimes != dailyWorkTime.workTimes)
            guard let self = self else { return }
            newDailyWorkTime.workTimes.isEmpty
                ? self.visibleDailyWorkTimes.removeAll { $0 == dailyWorkTime }
                : (self.visibleDailyWorkTimes[safeIndex: indexPath.section] = newDailyWorkTime)
        }
    }
    
    private func filterWorkTimesBySelectedProject() {
        self.visibleDailyWorkTimes = self.dailyWorkTimesFilteredBySelectedProject()
    }
    
    private func dailyWorkTimesFilteredBySelectedProject() -> [DailyWorkTime] {
        guard self.selectedProject != .allProjects else { return self.allDailyWorkTimes }
        return self.allDailyWorkTimes.compactMap { [selectedProject] dailyWorkTime in
            let workTimes = dailyWorkTime.workTimes.filter { $0.projectID == selectedProject.id }
            guard !workTimes.isEmpty else { return nil }
            return DailyWorkTime(day: dailyWorkTime.day, workTimes: workTimes)
        }
    }
    
    private func fetchRequiredData() {
        guard let date = self.selectedMonth.date.unwrapped(using: self.errorHandler) else { return }
        self.smoothLoadingManager.showActivityIndicatorWithDelay()
        self.prepareForFethingWorkTimes()
        self.contentProvider.fetchRequiredData(for: date) { [weak self] result in
            self?.smoothLoadingManager.hideActivityIndicator()
            switch result {
            case let .success(requiredData):
                self?.handleFetchSuccess(requiredData: requiredData)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    private func fetchWorkTimesData() {
        guard let date = self.selectedMonth.date.unwrapped(using: self.errorHandler) else { return }
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.prepareForFethingWorkTimes()
        self.contentProvider.fetchTimesheetData(for: date) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case let .success((dailyWorkTimes, matchingFullTime)):
                self?.handleFetchSuccess(dailyWorkTimes: dailyWorkTimes, matchingFullTime: matchingFullTime)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    private func prepareForFethingWorkTimes() {
        self.state = .fetching
        self.visibleDailyWorkTimes.removeAll()
        self.updateUI()
        self.userInterface?.updateAccountingPeriodLabel(text: nil)
    }
    
    private func handleFetchSuccess(requiredData: RequiredData) {
        self.projects = requiredData.simpleProjects
        self.handleFetchSuccess(dailyWorkTimes: requiredData.dailyWorkTimes, matchingFullTime: requiredData.matchingFulltime)
    }
    
    private func handleFetchSuccess(dailyWorkTimes: [DailyWorkTime], matchingFullTime: MatchingFullTimeDecoder) {
        self.allDailyWorkTimes = dailyWorkTimes
        self.state = .fetched
        self.updateUI()
        self.userInterface?.updateAccountingPeriodLabel(text: matchingFullTime.accountingPeriodText)
        self.userInterface?.showTableView()
    }
    
    private func handleFetch(error: Error) {
        if let error = error as? ApiClientError {
            if error.type == .unauthorized {
                self.errorHandler.throwing(error: error)
            } else {
                self.errorViewModel?.update(localizedError: error)
            }
        } else {
            self.errorViewModel?.update(localizedError: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.state = .error
        self.userInterface?.showErrorView()
    }
    
    private func updateUI() {
        self.updateWorkedHoursLabel()
        self.updateDateSelectorView()
        self.updateSelectedProjectView()
    }
    
    private func updateWorkedHoursLabel() {
        switch self.state {
        case .fetching:
            self.userInterface?.updateHoursLabel(workedHours: "")
        default:
            let duration = TimeInterval(self.visibleDailyWorkTimes.flatMap(\.workTimes).map(\.duration).reduce(0, +))
            let durationText = DateComponentsFormatter.timeAbbreviated.string(from: duration)
            self.userInterface?.updateHoursLabel(workedHours: durationText)
        }
    }
    
    private func updateDateSelectorView() {
        let currentDateString = self.string(for: self.selectedMonth)
        self.userInterface?.updateSelectedDate(currentDateString, date: (self.selectedMonth.month, self.selectedMonth.year))
    }
    
    private func updateSelectedProjectView() {
        self.userInterface?.updateSelectedProject(
            title: self.selectedProject.name,
            color: self.selectedProject.color)
    }
    
    private func string(for period: MonthPeriod) -> String {
        guard let monthSymbol = DateFormatter().standaloneMonthSymbols?[safeIndex: period.month - 1] else { return "" }
        return "\(monthSymbol.localizedCapitalized) \(period.year)"
    }
    
    private func getSectionsDiff(oldValue: [DailyWorkTime]) -> (insertions: IndexSet, removals: IndexSet) {
        let diff = self.visibleDailyWorkTimes.difference(from: oldValue)
        var insertions: IndexSet = IndexSet()
        var removals: IndexSet = IndexSet()
        diff.forEach { change in
            switch change {
            case let .insert(offset, _, _):
                insertions.insert(offset)
            case let .remove(offset, _, _):
                removals.insert(offset)
            }
        }
        return (insertions, removals)
    }
    
    private func getUpdatedSections(oldValue: [DailyWorkTime]) -> IndexSet {
        let sections: [Int] = self.visibleDailyWorkTimes.compactMap { dailyWorkTime in
            guard let oldSection = oldValue.firstIndex(of: dailyWorkTime),
                let oldDailyWorkTime = oldValue[safeIndex: oldSection] else { return nil }
            guard dailyWorkTime.workTimes != oldDailyWorkTime.workTimes else { return nil }
            return oldSection
        }
        return IndexSet(sections)
    }
    
    private func workTime(for indexPath: IndexPath) -> WorkTimeDecoder? {
        return self.dailyWorkTime(for: indexPath)?.workTimes.sorted(by: { $0.startsAt > $1.startsAt })[safeIndex: indexPath.row]
    }
    
    private func dailyWorkTime(for indexPath: IndexPath) -> DailyWorkTime? {
        return self.visibleDailyWorkTimes[safeIndex: indexPath.section]
    }
}
// swiftlint:disable:this file_length
