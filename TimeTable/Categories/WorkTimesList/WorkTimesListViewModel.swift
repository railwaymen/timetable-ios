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
    func updateDateSelector(currentDateString: String, previousDateString: String, nextDateString: String)
    func updateMatchingFullTimeLabels(workedHours: String, shouldWorkHours: String, duration: String)
    func setActivityIndicator(isHidden: Bool)
    func showTableView()
    func showErrorView()
    func insertSections(_ sections: IndexSet)
    func removeSections(_ sections: IndexSet)
    func reloadSections(_ sections: IndexSet)
    func performBatchUpdates(_ updates: (() -> Void)?)
}

protocol WorkTimesListViewModelType: class {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func viewDidLoad()
    func configure(_ view: ErrorViewable)
    func viewRequestForPreviousMonth()
    func viewRequestForNextMonth()
    func viewRequestForCellType(at index: IndexPath) -> WorkTimesListViewModel.CellType
    func configure(_ cell: WorkTimeTableViewCellable, for indexPath: IndexPath)
    func viewRequestForHeaderModel(at section: Int, header: WorkTimesTableViewHeaderViewModelOutput) -> WorkTimesTableViewHeaderViewModelType?
    func viewRequestToDuplicate(sourceView: UITableViewCell, at indexPath: IndexPath)
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void)
    func viewRequestTaskHistory(indexPath: IndexPath)
    func viewRequestForNewWorkTimeView(sourceView: UIView)
    func viewRequestedForEditEntry(sourceView: UITableViewCell, at indexPath: IndexPath)
    func viewRequestToRefresh(completion: @escaping () -> Void)
}

typealias WorkTimesListApiClientType = (ApiClientWorkTimesType & ApiClientMatchingFullTimeType)

class WorkTimesListViewModel {
    private weak var userInterface: WorkTimesListViewModelOutput?
    private weak var coordinator: WorkTimesListCoordinatorDelegate?
    private let contentProvider: WorkTimesListContentProviderType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private let messagePresenter: MessagePresenterType?
    
    private var selectedMonth: Date
    private var dailyWorkTimesArray: [DailyWorkTime] {
        didSet {
            guard #available(iOS 13, *) else {
                self.userInterface?.reloadData()
                return
            }
            let (insertedSections, removedSections) = self.getSectionsDiff(oldValue: oldValue)
            let (insertedRows, removedRows) = self.getRowsDiff(oldValue: oldValue)
            let updatedSections = IndexSet((insertedRows + removedRows).map { $0.section })
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
        userInterface: WorkTimesListViewModelOutput,
        coordinator: WorkTimesListCoordinatorDelegate?,
        contentProvider: WorkTimesListContentProviderType,
        errorHandler: ErrorHandlerType,
        calendar: CalendarType = Calendar.autoupdatingCurrent,
        messagePresenter: MessagePresenterType?
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.messagePresenter = messagePresenter
        
        self.dailyWorkTimesArray = []
        let components = calendar.dateComponents([.month, .year], from: Date())
        self.selectedMonth = calendar.date(from: components) ?? Date()
    }
}

// MARK: - Structures
extension WorkTimesListViewModel {
    enum CellType {
        case standard
        case taskURL
    }
}
 
// MARK: - WorkTimesListViewModelType
extension WorkTimesListViewModel: WorkTimesListViewModelType {
    func numberOfSections() -> Int {
        return self.dailyWorkTimesArray.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.dailyWorkTimesArray[safeIndex: section]?.workTimes.count ?? 0
    }
    
    func viewDidLoad() {
        self.userInterface?.setUpView()
        self.updateDateSelectorView(withCurrentDate: self.selectedMonth)
        self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
    }
    
    func configure(_ view: ErrorViewable) {
        let viewModel = ErrorViewModel(userInterface: view, error: UIError.genericError) { [weak self] in
            guard let self = self else { return }
            self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
        }
        view.configure(viewModel: viewModel)
        self.errorViewModel = viewModel
    }
    
    func viewRequestForPreviousMonth() {
        self.fetchAndChangeSelectedMonth(with: DateComponents(month: -1))
    }
    
    func viewRequestForNextMonth() {
        self.fetchAndChangeSelectedMonth(with: DateComponents(month: 1))
    }
    
    func viewRequestForCellType(at index: IndexPath) -> WorkTimesListViewModel.CellType {
        guard let workTime = self.workTime(for: index) else { return .standard }
        return workTime.taskPreview == nil ? .standard : .taskURL
    }
    
    func configure(_ cell: WorkTimeTableViewCellable, for indexPath: IndexPath) {
        guard let workTime = self.workTime(for: indexPath) else { return }
        let viewModel = WorkTimeTableViewCellModel(
            workTime: workTime,
            userInterface: cell,
            parent: self)
        cell.configure(viewModel: viewModel)
    }
    
    func viewRequestForHeaderModel(at section: Int, header: WorkTimesTableViewHeaderViewModelOutput) -> WorkTimesTableViewHeaderViewModelType? {
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
        self.messagePresenter?.requestDecision(
            title: "work_times.delete_alert.title".localized,
            message: "work_times.delete_alert.message".localized,
            cancelButtonConfig: ButtonConfig(title: "work_times.delete_alert.cancel".localized, style: .cancel, action: { completion(false) }),
            confirmButtonConfig: ButtonConfig(title: "work_times.delete_alert.confirm".localized, style: .destructive, action: { [weak self] in
                guard let self = self else { return completion(false) }
                self.contentProvider.delete(workTime: workTime) { [weak self] result in
                    guard let self = self else { return completion(false) }
                    switch result {
                    case .success:
                        self.removeDailyWorkTime(at: index, workTime: workTime, completion: completion)
                    case let .failure(error):
                        self.errorHandler.throwing(error: error)
                        completion(false)
                    }
                }
            }))
    }
    
    func viewRequestTaskHistory(indexPath: IndexPath) {
        guard let taskForm = self.createTaskForm(for: indexPath) else { return }
        self.coordinator?.workTimesRequestedForTaskHistory(taskForm: taskForm)
    }
    
    func viewRequestForNewWorkTimeView(sourceView: UIView) {
        let lastTask = self.createTaskForm(for: IndexPath(row: 0, section: 0))
        self.coordinator?.workTimesRequestedForWorkTimeView(sourceView: sourceView, flowType: .newEntry(lastTask: lastTask)) { [weak self] isTaskChanged in
            guard let self = self, isTaskChanged else { return }
            self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
        }
    }
    
    func viewRequestedForEditEntry(sourceView: UITableViewCell, at indexPath: IndexPath) {
        guard let task = self.createTaskForm(for: indexPath) else { return }
        self.coordinator?.workTimesRequestedForWorkTimeView(sourceView: sourceView, flowType: .editEntry(editedTask: task)) { [weak self] isTaskChanged in
            guard let self = self, isTaskChanged else { return }
            self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
        }
    }
    
    func viewRequestToRefresh(completion: @escaping () -> Void) {
        self.contentProvider.fetchWorkTimesData(for: self.selectedMonth) { [weak self] result in
            defer { completion() }
            switch result {
            case let .success(dailyWorkTimes, matchingFullTime):
                self?.handleFetchSuccess(dailyWorkTimes: dailyWorkTimes, matchingFullTime: matchingFullTime)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
}

// MARK: - WorkTimeTableViewCellViewModelParentType
extension WorkTimesListViewModel: WorkTimeTableViewCellModelParentType {
    func openTask(for workTime: WorkTimeDecoder) {
        guard let task = workTime.task, let url = URL(string: task) else { return }
        self.coordinator?.workTimesRequestedForSafari(url: url)
    }
}

// MARK: - Private
extension WorkTimesListViewModel {
    private func createTaskForm(for indexPath: IndexPath) -> TaskForm? {
        guard let dailyWorkTime = self.dailyWorkTime(for: indexPath) else { return nil }
        guard let workTime = self.workTime(for: indexPath) else { return nil }
        let url: URL?
        if let taskUrlString = workTime.task {
            url = URL(string: taskUrlString)
        } else {
            url = nil
        }
        return TaskForm(
            workTimeIdentifier: workTime.identifier,
            project: workTime.project,
            body: workTime.body ?? "",
            url: url,
            day: dailyWorkTime.day,
            startsAt: workTime.startsAt,
            endsAt: workTime.endsAt,
            tag: workTime.tag)
    }
    
    private func removeDailyWorkTime(at indexPath: IndexPath, workTime: WorkTimeDecoder, completion: @escaping (Bool) -> Void) {
        guard let dailyWorkTime = self.dailyWorkTime(for: indexPath),
            let userInterface = self.userInterface else { return completion(false) }
        let isDeleted = dailyWorkTime.remove(workTime: workTime)
        userInterface.performBatchUpdates { [weak self] in
            completion(isDeleted)
            self?.dailyWorkTimesArray.removeAll { $0.workTimes.isEmpty }
        }
    }
    
    private func fetchAndChangeSelectedMonth(with components: DateComponents) {
        guard let newSelectedMonth = self.calendar.date(byAdding: components, to: self.selectedMonth) else { return }
        self.selectedMonth = newSelectedMonth
        self.updateDateSelectorView(withCurrentDate: newSelectedMonth)
        self.fetchWorkTimesData(forCurrentMonth: newSelectedMonth)
    }
    
    private func updateDateSelectorView(withCurrentDate date: Date?) {
        guard let currentDate = date else { return }
        guard let previousDate = self.calendar.date(byAdding: DateComponents(month: -1), to: currentDate) else { return }
        guard let nextDate = self.calendar.date(byAdding: DateComponents(month: 1), to: currentDate) else { return }
        let currentDateString = self.string(for: currentDate)
        let previousDateString = self.string(for: previousDate)
        let nextDateString = self.string(for: nextDate)
        self.userInterface?.updateDateSelector(currentDateString: currentDateString, previousDateString: previousDateString, nextDateString: nextDateString)
    }
    
    private func fetchWorkTimesData(forCurrentMonth date: Date) {
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.dailyWorkTimesArray.removeAll()
        self.userInterface?.updateMatchingFullTimeLabels(workedHours: "", shouldWorkHours: "", duration: "")
        self.contentProvider.fetchWorkTimesData(for: date) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case let .success(dailyWorkTimes, matchingFullTime):
                self?.handleFetchSuccess(dailyWorkTimes: dailyWorkTimes, matchingFullTime: matchingFullTime)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    private func handleFetchSuccess(dailyWorkTimes: [DailyWorkTime], matchingFullTime: MatchingFullTimeDecoder) {
        self.dailyWorkTimesArray = dailyWorkTimes
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        let defaultValue = "00:00"
        var time: (workedHours: String, shouldWorkHours: String, duration: String) = (defaultValue, defaultValue, defaultValue)
        if let countedDuration = matchingFullTime.period?.countedDuration {
            time.workedHours = formatter.string(from: countedDuration) ?? defaultValue
        }
        if let shouldWorked = matchingFullTime.shouldWorked {
            time.shouldWorkHours = formatter.string(from: shouldWorked) ?? defaultValue
        }
        if let duration = matchingFullTime.period?.duration {
            time.duration = formatter.string(from: duration) ?? defaultValue
        }
        self.userInterface?.updateMatchingFullTimeLabels(
            workedHours: time.workedHours,
            shouldWorkHours: time.shouldWorkHours,
            duration: time.duration)
        self.userInterface?.showTableView()
    }
    
    private func handleFetch(error: Error) {
        if let error = error as? ApiClientError {
            self.errorViewModel?.update(error: error)
        } else {
            self.errorViewModel?.update(error: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.userInterface?.showErrorView()
    }
    
    private func string(for date: Date) -> String {
        let components = self.calendar.dateComponents([.month, .year], from: date)
        guard let month = components.month, let year = components.year else { return "" }
        guard let monthSymbol = DateFormatter().shortMonthSymbols?[safeIndex: month - 1] else { return "" }
        return "\(monthSymbol) \(year)"
    }
    
    @available(iOS 13, *)
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
    
    @available(iOS 13, *)
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
