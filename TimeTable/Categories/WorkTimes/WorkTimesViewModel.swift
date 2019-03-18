//
//  WorkTimesViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import UIKit

protocol WorkTimesViewModelOutput: class {
    func setUpView()
    func updateView()
    func updateDateSelector(currentDateString: String, previousDateString: String, nextDateString: String)
    func updateMatchingFullTimeLabels(workedHours: String, shouldWorkHours: String, duration: String)
    func deleteWorkTime(at indexPath: IndexPath)
    func reloadWorkTime(at indexPath: IndexPath)
}

protocol WorkTimesViewModelType: class {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func viewDidLoad()
    func viewWillAppear()
    func viewRequestedForPreviousMonth()
    func viewRequestedForNextMonth()
    func viewRequestedForCellType(at index: IndexPath) -> WorkTimesViewModel.CellType
    func viewRequestedForCellModel(at index: IndexPath, cell: WorkTimeCellViewModelOutput) -> WorkTimeCellViewModelType?
    func viewRequestedForHeaderModel(at section: Int, header: WorkTimesTableViewHeaderViewModelOutput) -> WorkTimesTableViewHeaderViewModelType?
    func viewRequestedForDelete(at index: IndexPath)
    func viewRequestedForNewWorkTimeView(sourceView: UIButton)
}

class DailyWorkTime {
    let day: Date
    var workTimes: [WorkTimeDecoder]
    
    // MARK: - Initialization
    init(day: Date, workTimes: [WorkTimeDecoder]) {
        self.day = day
        self.workTimes = workTimes
    }
    
    func remove(workTime: WorkTimeDecoder) -> Bool {
        guard let index = workTimes.firstIndex(of: workTime) else { return false }
        workTimes.remove(at: index)
        return true
    }
}

typealias WorkTimesApiClientType = (ApiClientWorkTimesType & ApiClientMatchingFullTimeType)

class WorkTimesViewModel: WorkTimesViewModelType {
    private weak var userInterface: WorkTimesViewModelOutput?
    private let coordinator: WorkTimesCoordinatorDelegate
    private let contentProvider: WorkTimesContentProviderType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private var selectedMonth: Date?
    private var dailyWorkTimesArray: [DailyWorkTime]
    
    enum CellType {
        case standard
        case taskURL
    }
    
    // MARK: - Initialization
    init(userInterface: WorkTimesViewModelOutput, coordinator: WorkTimesCoordinatorDelegate, contentProvider: WorkTimesContentProviderType,
         errorHandler: ErrorHandlerType, calendar: CalendarType = Calendar.autoupdatingCurrent) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.dailyWorkTimesArray = []
        let components = calendar.dateComponents([.month, .year], from: Date())
        self.selectedMonth = calendar.date(from: components)
    }
    
    // MARK: - WorkTimesViewModelType
    func numberOfSections() -> Int {
        return dailyWorkTimesArray.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return (dailyWorkTimesArray.count > section) ? dailyWorkTimesArray[section].workTimes.count : 0
    }
    
    func viewDidLoad() {
        userInterface?.setUpView()
        updateDateSelectorView(withCurrentDate: selectedMonth)
    }
    
    func viewWillAppear() {
        fetchWorkTimesData(forCurrentMonth: selectedMonth)
    }
    
    func viewRequestedForPreviousMonth() {
        fetchAndChangeSelectedMonth(with: DateComponents(month: -1))
    }
    
    func viewRequestedForNextMonth() {
        fetchAndChangeSelectedMonth(with: DateComponents(month: 1))
    }
    
    func viewRequestedForCellType(at index: IndexPath) -> WorkTimesViewModel.CellType {
        guard let workTime = workTime(for: index) else { return .standard }
        return workTime.taskPreview == nil ? .standard : .taskURL
    }
    
    func viewRequestedForCellModel(at index: IndexPath, cell: WorkTimeCellViewModelOutput) -> WorkTimeCellViewModelType? {
        guard let workTime = workTime(for: index) else { return nil }
        return WorkTimeCellViewModel(workTime: workTime, userInterface: cell)
    }
    
    func viewRequestedForHeaderModel(at section: Int, header: WorkTimesTableViewHeaderViewModelOutput) -> WorkTimesTableViewHeaderViewModelType? {
        guard dailyWorkTimesArray.count > section else { return nil }
        return WorkTimesTableViewHeaderViewModel(userInterface: header, dailyWorkTime: dailyWorkTimesArray[section])
    }
    
    func viewRequestedForDelete(at index: IndexPath) {
        guard let workTime = workTime(for: index) else { return }
        contentProvider.delete(workTime: workTime) { [weak self] result in
            switch result {
            case .success:
                if let deleted = self?.dailyWorkTime(for: index)?.remove(workTime: workTime), deleted {
                    self?.userInterface?.deleteWorkTime(at: index)
                } else {
                    self?.userInterface?.reloadWorkTime(at: index)
                }
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    func viewRequestedForNewWorkTimeView(sourceView: UIButton) {
        let lastWorkTime = dailyWorkTimesArray.first?.workTimes.first
        let lastTask = lastWorkTime == nil
            ? nil
            : Task(project: lastWorkTime?.project,
                   body: lastWorkTime?.body ?? "",
                   url: nil,
                   day: dailyWorkTimesArray.first?.day,
                   startAt: lastWorkTime?.startsAt,
                   endAt: lastWorkTime?.endsAt)
        coordinator.workTimesRequestedForNewWorkTimeView(sourceView: sourceView, lastTask: lastTask)
    }
    
    // MARK: - Private
    private func workTime(for indexPath: IndexPath) -> WorkTimeDecoder? {
        return dailyWorkTime(for: indexPath)?.workTimes.sorted(by: { $0.startsAt > $1.startsAt })[indexPath.row]
    }
    
    private func dailyWorkTime(for indexPath: IndexPath) -> DailyWorkTime? {
        guard dailyWorkTimesArray.count > indexPath.section else { return nil }
        return dailyWorkTimesArray[indexPath.section]
    }
    
    private func removeDailyWorkTime(at indexPath: IndexPath) {
        
    }
    
    private func fetchWorkTimesData(forCurrentMonth date: Date?) {
        contentProvider.fetchWorkTimesData(for: date) { [weak self] result in
            switch result {
            case .success(let dailyWorkTimes, let matchingFullTime):
                self?.dailyWorkTimesArray = dailyWorkTimes
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
                self?.userInterface?.updateMatchingFullTimeLabels(workedHours: time.workedHours,
                                                                  shouldWorkHours: time.shouldWorkHours,
                                                                  duration: time.duration)
                self?.userInterface?.updateView()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    private func fetchAndChangeSelectedMonth(with components: DateComponents) {
        guard let date = selectedMonth else { return }
        let newComponents = newDateComponents(for: date, oldComponents: components)
        let newSelectedMonth = calendar.date(byAdding: newComponents, to: date)
        selectedMonth = newSelectedMonth
        updateDateSelectorView(withCurrentDate: newSelectedMonth)
        fetchWorkTimesData(forCurrentMonth: newSelectedMonth)
    }
    
    private func updateDateSelectorView(withCurrentDate date: Date?) {
        guard let currentDate = date else { return }
        let previousDateComponents = newDateComponents(for: currentDate, oldComponents: DateComponents(month: -1))
        let nextDateComponents = newDateComponents(for: currentDate, oldComponents: DateComponents(month: 1))
        guard let previousDate = calendar.date(byAdding: previousDateComponents, to: currentDate) else { return }
        guard let nextDate = calendar.date(byAdding: nextDateComponents, to: currentDate) else { return }
        let currentDateString = string(for: currentDate)
        let previousDateString = string(for: previousDate)
        let nextDateString = string(for: nextDate)
        userInterface?.updateDateSelector(currentDateString: currentDateString, previousDateString: previousDateString, nextDateString: nextDateString)
    }
    
    private func newDateComponents(for date: Date, oldComponents: DateComponents) -> DateComponents {
        var newComponents = oldComponents
        guard let month = calendar.dateComponents([.month], from: date).month else { return newComponents }
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
        let components = calendar.dateComponents([.month, .year], from: date)
        guard let month = components.month, let year = components.year else { return "" }
        guard let monthSymbol = DateFormatter().shortMonthSymbols?[month - 1] else { return "" }
        return "\(monthSymbol) \(year)"
    }
}
