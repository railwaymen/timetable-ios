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
    func updateView()
    func updateDateSelector(currentDateString: String, previousDateString: String, nextDateString: String)
    func updateMatchingFullTimeLabels(workedHours: String, shouldWorkHours: String, duration: String)
    func setActivityIndicator(isHidden: Bool)
    func showTableView()
    func showErrorView()
}

protocol WorkTimesListViewModelType: class {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func viewDidLoad()
    func configure(_ view: ErrorViewable)
    func viewRequestForPreviousMonth()
    func viewRequestForNextMonth()
    func viewRequestForCellType(at index: IndexPath) -> WorkTimesListViewModel.CellType
    func viewRequestForCellModel(at index: IndexPath, cell: WorkTimeCellViewModelOutput) -> WorkTimeCellViewModelType?
    func viewRequestForHeaderModel(at section: Int, header: WorkTimesTableViewHeaderViewModelOutput) -> WorkTimesTableViewHeaderViewModelType?
    func viewRequestToDuplicate(sourceView: UITableViewCell, at indexPath: IndexPath)
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void)
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
    
    private var selectedMonth: Date?
    private var dailyWorkTimesArray: [DailyWorkTime]
    private weak var errorViewModel: ErrorViewModelParentType?
    
    // MARK: - Initialization
    init(
        userInterface: WorkTimesListViewModelOutput,
        coordinator: WorkTimesListCoordinatorDelegate?,
        contentProvider: WorkTimesListContentProviderType,
        errorHandler: ErrorHandlerType,
        calendar: CalendarType = Calendar.autoupdatingCurrent
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.dailyWorkTimesArray = []
        let components = calendar.dateComponents([.month, .year], from: Date())
        self.selectedMonth = calendar.date(from: components)
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
        return (self.dailyWorkTimesArray.count > section) ? self.dailyWorkTimesArray[section].workTimes.count : 0
    }
    
    func viewDidLoad() {
        self.userInterface?.setUpView()
        self.updateDateSelectorView(withCurrentDate: self.selectedMonth)
        self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth)
    }
    
    func configure(_ view: ErrorViewable) {
        let viewModel = ErrorViewModel(userInterface: view, error: UIError.genericError) { [weak self] in
            self?.fetchWorkTimesData(forCurrentMonth: self?.selectedMonth)
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
    
    func viewRequestForCellModel(at index: IndexPath, cell: WorkTimeCellViewModelOutput) -> WorkTimeCellViewModelType? {
        guard let workTime = self.workTime(for: index) else { return nil }
        return WorkTimeCellViewModel(workTime: workTime, userInterface: cell, parent: self)
    }
    
    func viewRequestForHeaderModel(at section: Int, header: WorkTimesTableViewHeaderViewModelOutput) -> WorkTimesTableViewHeaderViewModelType? {
        guard self.dailyWorkTimesArray.count > section else { return nil }
        return WorkTimesTableViewHeaderViewModel(userInterface: header, dailyWorkTime: self.dailyWorkTimesArray[section])
    }
    
    func viewRequestToDuplicate(sourceView: UITableViewCell, at indexPath: IndexPath) {
        guard let task = self.createTask(for: indexPath) else { return }
        let lastTask = self.createTask(for: IndexPath(row: 0, section: 0))
        self.coordinator?.workTimesRequestedForWorkTimeView(
            sourceView: sourceView,
            flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask)) { [weak self] isTaskChanged in
                guard isTaskChanged else { return }
                self?.fetchWorkTimesData(forCurrentMonth: self?.selectedMonth)
            }
    }
    
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void) {
        guard let workTime = self.workTime(for: index) else { return completion(false) }
        self.contentProvider.delete(workTime: workTime) { [weak self] result in
            switch result {
            case .success:
                self?.removeDailyWorkTime(at: index, workTime: workTime, completion: completion)
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
                completion(false)
            }
        }
    }
    
    func viewRequestForNewWorkTimeView(sourceView: UIView) {
        let lastTask = self.createTask(for: IndexPath(row: 0, section: 0))
        self.coordinator?.workTimesRequestedForWorkTimeView(sourceView: sourceView, flowType: .newEntry(lastTask: lastTask)) { [weak self] isTaskChanged in
            guard isTaskChanged else { return }
            self?.fetchWorkTimesData(forCurrentMonth: self?.selectedMonth)
        }
    }
    
    func viewRequestedForEditEntry(sourceView: UITableViewCell, at indexPath: IndexPath) {
        guard let task = self.createTask(for: indexPath) else { return }
        self.coordinator?.workTimesRequestedForWorkTimeView(sourceView: sourceView, flowType: .editEntry(editedTask: task)) { [weak self] isTaskChanged in
            guard isTaskChanged else { return }
            self?.fetchWorkTimesData(forCurrentMonth: self?.selectedMonth)
        }
    }
    
    func viewRequestToRefresh(completion: @escaping () -> Void) {
        self.fetchWorkTimesData(forCurrentMonth: self.selectedMonth, completion: completion)
    }
}

// MARK: - WorkTimeCellViewModelParentType
extension WorkTimesListViewModel: WorkTimeCellViewModelParentType {
    func openTask(for workTime: WorkTimeDecoder) {
        guard let task = workTime.task, let url = URL(string: task) else { return }
        self.coordinator?.workTimesRequestedForSafari(url: url)
    }
}

// MARK: - Private
extension WorkTimesListViewModel {
    private func workTime(for indexPath: IndexPath) -> WorkTimeDecoder? {
        return self.dailyWorkTime(for: indexPath)?.workTimes.sorted(by: { $0.startsAt > $1.startsAt })[indexPath.row]
    }
    
    private func dailyWorkTime(for indexPath: IndexPath) -> DailyWorkTime? {
        guard self.dailyWorkTimesArray.count > indexPath.section else { return nil }
        return self.dailyWorkTimesArray[indexPath.section]
    }
    
    private func createTask(for indexPath: IndexPath) -> Task? {
        guard let dailyWorkTime = self.dailyWorkTime(for: indexPath) else { return nil }
        guard let workTime = self.workTime(for: indexPath) else { return nil }
        let url: URL?
        if let taskUrlString = workTime.task {
            url = URL(string: taskUrlString)
        } else {
            url = nil
        }
        return Task(
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
        guard let dailyWorkTime = self.dailyWorkTime(for: indexPath) else { return completion(false) }
        let isDeleted = dailyWorkTime.remove(workTime: workTime)
        completion(isDeleted)
    }
    
    private func fetchWorkTimesData(forCurrentMonth date: Date?, completion: (() -> Void)? = nil) {
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.contentProvider.fetchWorkTimesData(for: date) { [weak self] result in
            defer {
                completion?()
            }
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .success(let dailyWorkTimes, let matchingFullTime):
                self?.handleFetchSuccess(dailyWorkTimes: dailyWorkTimes, matchingFullTime: matchingFullTime)
            case .failure(let error):
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
            time.workedHours = formatter.string(from: countedDuration ) ?? defaultValue
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
        self.userInterface?.updateView()
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
    
    private func fetchAndChangeSelectedMonth(with components: DateComponents) {
        guard let date = self.selectedMonth else { return }
        let newComponents = self.newDateComponents(for: date, oldComponents: components)
        let newSelectedMonth = self.calendar.date(byAdding: newComponents, to: date)
        self.selectedMonth = newSelectedMonth
        self.updateDateSelectorView(withCurrentDate: newSelectedMonth)
        self.fetchWorkTimesData(forCurrentMonth: newSelectedMonth)
    }
    
    private func updateDateSelectorView(withCurrentDate date: Date?) {
        guard let currentDate = date else { return }
        let previousDateComponents = self.newDateComponents(for: currentDate, oldComponents: DateComponents(month: -1))
        let nextDateComponents = self.newDateComponents(for: currentDate, oldComponents: DateComponents(month: 1))
        guard let previousDate = self.calendar.date(byAdding: previousDateComponents, to: currentDate) else { return }
        guard let nextDate = self.calendar.date(byAdding: nextDateComponents, to: currentDate) else { return }
        let currentDateString = self.string(for: currentDate)
        let previousDateString = self.string(for: previousDate)
        let nextDateString = self.string(for: nextDate)
        self.userInterface?.updateDateSelector(currentDateString: currentDateString, previousDateString: previousDateString, nextDateString: nextDateString)
    }
    
    private func newDateComponents(for date: Date, oldComponents: DateComponents) -> DateComponents {
        var newComponents = oldComponents
        guard let month = self.calendar.dateComponents([.month], from: date).month else { return newComponents }
        if let componentsMonth = oldComponents.month {
            if month == 1 && componentsMonth == -1 {
                newComponents.year = -1
            } else if month == 12 && componentsMonth == 1 {
                newComponents.year = 1
            }
        }
        return newComponents
    }
    
    private func string(for date: Date) -> String {
        let components = self.calendar.dateComponents([.month, .year], from: date)
        guard let month = components.month, let year = components.year else { return "" }
        guard let monthSymbol = DateFormatter().shortMonthSymbols?[month - 1] else { return "" }
        return "\(monthSymbol) \(year)"
    }
}
