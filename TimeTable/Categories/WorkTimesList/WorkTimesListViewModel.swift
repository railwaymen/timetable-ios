//
//  WorkTimesListViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import UIKit

protocol WorkTimesListViewModelOutput: class {
    func setUpView()
    func reloadData()
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
    func setBottomContentInset(_ height: CGFloat)
}

protocol WorkTimesListViewModelType: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidLayoutSubviews()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func configure(_ view: ErrorViewable)
    func viewRequestForNewDate(month: Int, year: Int)
    func viewRequestForCellType(at index: IndexPath) -> WorkTimesListViewModel.CellType
    func configure(_ cell: WorkTimeTableViewCellable, for indexPath: IndexPath)
    func viewRequestForHeaderModel(
        at section: Int,
        header: WorkTimesTableViewHeaderViewModelOutput) -> WorkTimesTableViewHeaderViewModelType?
    func viewRequestToDuplicate(sourceView: UITableViewCell, at indexPath: IndexPath)
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void)
    func viewRequestTaskHistory(indexPath: IndexPath)
    func viewRequestForNewWorkTimeView(sourceView: UIView)
    func viewRequestedForEditEntry(sourceView: UITableViewCell, at indexPath: IndexPath)
    func viewRequestToRefresh(completion: @escaping () -> Void)
    func viewRequestForProfileView()
}

typealias WorkTimesListApiClientType = (ApiClientWorkTimesType & ApiClientAccountingPeriodsType)

class WorkTimesListViewModel {
    private weak var userInterface: WorkTimesListViewModelOutput?
    private weak var coordinator: WorkTimesListCoordinatorDelegate?
    private let contentProvider: WorkTimesListContentProviderType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private let messagePresenter: MessagePresenterType?
    private let notificationCenter: NotificationCenterType
    
    private var selectedMonth: MonthPeriod {
        didSet {
            guard self.selectedMonth != oldValue else { return }
            self.updateDateSelectorView(withCurrentMonth: self.selectedMonth)
            self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
        }
    }
    
    private var state: State?
    private var didViewLayoutSubviews: Bool = false {
        didSet {
            guard self.didViewLayoutSubviews else { return }
            self.userInterface?.reloadData()
        }
    }
    
    private var dailyWorkTimesArray: [DailyWorkTime] {
        didSet {
            guard self.didViewLayoutSubviews else { return }
            let (insertedSections, removedSections) = self.getSectionsDiff(oldValue: oldValue)
            let (insertedRows, removedRows) = self.getRowsDiff(oldValue: oldValue)
            let updatedSections = IndexSet((insertedRows + removedRows).map(\.section))
            self.userInterface?.performBatchUpdates { [weak userInterface] in
                userInterface?.removeSections(removedSections)
                userInterface?.insertSections(insertedSections)
                userInterface?.reloadSections(updatedSections)
            }
        }
    }
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .default
        return formatter
    }()
    
    private weak var errorViewModel: ErrorViewModelParentType?
    
    // MARK: - Initialization
    init(
        userInterface: WorkTimesListViewModelOutput,
        coordinator: WorkTimesListCoordinatorDelegate?,
        contentProvider: WorkTimesListContentProviderType,
        errorHandler: ErrorHandlerType,
        calendar: CalendarType = Calendar.autoupdatingCurrent,
        messagePresenter: MessagePresenterType?,
        notificationCenter: NotificationCenterType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.messagePresenter = messagePresenter
        self.notificationCenter = notificationCenter
        
        self.dailyWorkTimesArray = []
        self.selectedMonth = MonthPeriod()
        
        self.setUpNotifications()
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc func changeKeyboardFrame(notification: NSNotification) {
        let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight = userInfo?.cgRectValue.size.height else { return }
        self.userInterface?.setBottomContentInset(keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        self.userInterface?.setBottomContentInset(0)
    }
}

// MARK: - Structures
extension WorkTimesListViewModel {
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
 
// MARK: - WorkTimesListViewModelType
extension WorkTimesListViewModel: WorkTimesListViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUpView()
    }
    
    func viewWillAppear() {
        guard self.state == .none else { return }
        self.updateDateSelectorView(withCurrentMonth: self.selectedMonth)
        self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
    }
    
    func viewDidLayoutSubviews() {
        guard !self.didViewLayoutSubviews else { return }
        self.didViewLayoutSubviews = true
    }
    
    func numberOfSections() -> Int {
        return self.dailyWorkTimesArray.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.dailyWorkTimesArray[safeIndex: section]?.workTimes.count ?? 0
    }
    
    func configure(_ view: ErrorViewable) {
        let viewModel = ErrorViewModel(userInterface: view, error: UIError.genericError) { [weak self] in
            guard let self = self else { return }
            self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
        }
        view.configure(viewModel: viewModel)
        self.errorViewModel = viewModel
    }
    
    func viewRequestForNewDate(month: Int, year: Int) {
        self.selectedMonth = MonthPeriod(month: month, year: year)
    }
    
    func viewRequestForCellType(at index: IndexPath) -> WorkTimesListViewModel.CellType {
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
        header: WorkTimesTableViewHeaderViewModelOutput
    ) -> WorkTimesTableViewHeaderViewModelType? {
        guard let dailyWorkTime = self.dailyWorkTimesArray[safeIndex: section] else { return nil }
        return WorkTimesTableViewHeaderViewModel(userInterface: header, dailyWorkTime: dailyWorkTime)
    }
    
    func viewRequestToDuplicate(sourceView: UITableViewCell, at indexPath: IndexPath) {
        guard let task = self.createTaskForm(for: indexPath) else { return }
        let lastTask = self.createTaskForm(for: IndexPath(row: 0, section: 0))
        self.coordinator?.workTimesRequestedForWorkTimeView(
            sourceView: sourceView,
            flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask)) { [weak self] isTaskChanged in
                guard let self = self, isTaskChanged else { return }
                self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
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
        self.coordinator?.workTimesRequestedForTaskHistory(taskForm: taskForm)
    }
    
    func viewRequestForNewWorkTimeView(sourceView: UIView) {
        let lastTask = self.createTaskForm(for: IndexPath(row: 0, section: 0))
        self.coordinator?.workTimesRequestedForWorkTimeView(
            sourceView: sourceView,
            flowType: .newEntry(lastTask: lastTask)) { [weak self] isTaskChanged in
                guard let self = self, isTaskChanged else { return }
                self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
        }
    }
    
    func viewRequestedForEditEntry(sourceView: UITableViewCell, at indexPath: IndexPath) {
        guard let task = self.createTaskForm(for: indexPath) else { return }
        self.coordinator?.workTimesRequestedForWorkTimeView(
            sourceView: sourceView,
            flowType: .editEntry(editedTask: task)) { [weak self] isTaskChanged in
                guard let self = self, isTaskChanged else { return }
                self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
        }
    }
    
    func viewRequestToRefresh(completion: @escaping () -> Void) {
        guard let date = self.selectedMonth.date else {
            self.errorHandler.stopInDebug()
            return
        }
        self.contentProvider.fetchWorkTimesData(for: date) { [weak self] result in
            defer { completion() }
            switch result {
            case let .success((dailyWorkTimes, matchingFullTime)):
                self?.handleFetchSuccess(dailyWorkTimes: dailyWorkTimes, matchingFullTime: matchingFullTime)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    func viewRequestForProfileView() {
        self.coordinator?.workTimesRequestedForProfileView()
    }
}

// MARK: - WorkTimeTableViewCellViewModelParentType
extension WorkTimesListViewModel: WorkTimeTableViewCellModelParentType {
    func openTask(for workTime: WorkTimeDisplayed) {
        guard let task = workTime.task, let url = URL(string: task) else { return }
        self.coordinator?.workTimesRequestedForSafari(url: url)
    }
}

// MARK: - Private
extension WorkTimesListViewModel {
    private func setUpNotifications() {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.changeKeyboardFrame),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.changeKeyboardFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
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
                ? self.dailyWorkTimesArray.removeAll { $0 == dailyWorkTime }
                : (self.dailyWorkTimesArray[safeIndex: indexPath.section] = newDailyWorkTime)
        }
    }
    
    private func updateDateSelectorView(withCurrentMonth period: MonthPeriod) {
        let currentDateString = self.string(for: period)
        self.userInterface?.updateSelectedDate(currentDateString, date: (period.month, period.year))
    }
    
    private func fetchWorkTimesData(forCurrentMonth period: MonthPeriod) {
        guard let date = period.date else {
            self.errorHandler.stopInDebug()
            return
        }
        self.state = .fetching
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.dailyWorkTimesArray.removeAll()
        self.userInterface?.updateHoursLabel(workedHours: "")
        self.userInterface?.updateAccountingPeriodLabel(text: nil)
        self.contentProvider.fetchWorkTimesData(for: date) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case let .success((dailyWorkTimes, matchingFullTime)):
                self?.handleFetchSuccess(dailyWorkTimes: dailyWorkTimes, matchingFullTime: matchingFullTime)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    private func handleFetchSuccess(dailyWorkTimes: [DailyWorkTime], matchingFullTime: MatchingFullTimeDecoder) {
        self.dailyWorkTimesArray = dailyWorkTimes
        self.state = .fetched
        self.updateWorkedHoursLabel()
        self.userInterface?.updateAccountingPeriodLabel(text: matchingFullTime.accountingPeriodText)
        self.userInterface?.showTableView()
    }
    
    private func updateWorkedHoursLabel() {
        let duration = TimeInterval(self.dailyWorkTimesArray.flatMap(\.workTimes).map(\.duration).reduce(0, +))
        let durationText = self.dateComponentsFormatter.string(from: duration)
        self.userInterface?.updateHoursLabel(workedHours: durationText)
    }
    
    private func handleFetch(error: Error) {
        if let error = error as? ApiClientError {
            if error.type == .unauthorized {
                self.errorHandler.throwing(error: error)
            } else {
                self.errorViewModel?.update(error: error)
            }
        } else {
            self.errorViewModel?.update(error: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.state = .error
        self.userInterface?.showErrorView()
    }
    
    private func string(for period: MonthPeriod) -> String {
        guard let monthSymbol = DateFormatter().standaloneMonthSymbols?[safeIndex: period.month - 1] else { return "" }
        return "\(monthSymbol.localizedCapitalized) \(period.year)"
    }
    
    private func getSectionsDiff(oldValue: [DailyWorkTime]) -> (insertions: IndexSet, removals: IndexSet) {
        let diff = self.dailyWorkTimesArray.difference(from: oldValue)
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
    
    private func getRowsDiff(oldValue: [DailyWorkTime]) -> (insertions: [IndexPath], removals: [IndexPath]) {
        var insertions: [IndexPath] = []
        var removals: [IndexPath] = []
        
        self.dailyWorkTimesArray.enumerated().forEach { (newSection, dailyWorkTime) in
            guard let oldSection = oldValue.firstIndex(of: dailyWorkTime),
                let oldDailyWorkTime = oldValue[safeIndex: oldSection] else { return }
            let diff = dailyWorkTime.workTimes.difference(from: oldDailyWorkTime.workTimes)
            diff.forEach { change in
                switch change {
                case let .insert(offset, _, _):
                    insertions.append(IndexPath(row: offset, section: newSection))
                case let .remove(offset, _, _):
                    removals.append(IndexPath(row: offset, section: oldSection))
                }
            }
        }
        return (insertions, removals)
    }
    
    private func workTime(for indexPath: IndexPath) -> WorkTimeDecoder? {
        return self.dailyWorkTime(for: indexPath)?.workTimes.sorted(by: { $0.startsAt > $1.startsAt })[safeIndex: indexPath.row]
    }
    
    private func dailyWorkTime(for indexPath: IndexPath) -> DailyWorkTime? {
        return self.dailyWorkTimesArray[safeIndex: indexPath.section]
    }
}
// swiftlint:disable:this file_length
