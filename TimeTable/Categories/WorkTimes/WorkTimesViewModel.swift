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
}

class WorkTimesViewModel: WorkTimesViewModelType {
    private weak var userInterface: WorkTimesViewModelOutput?
    private let coordinator: WorkTimesCoordinatorDelegate
    private let apiClient: ApiClientWorkTimesType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private var selectedMonth: Date?
    private var dailyWorkTimesArray: [DailyWorkTime]
    
    enum CellType {
        case standard
        case taskURL
    }
    
    // MARK: - Initialization
    init(userInterface: WorkTimesViewModelOutput, coordinator: WorkTimesCoordinatorDelegate, apiClient: ApiClientWorkTimesType,
         errorHandler: ErrorHandlerType, calendar: CalendarType = Calendar.autoupdatingCurrent) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.dailyWorkTimesArray = []
        let components = Calendar.current.dateComponents([.month, .year], from: Date())
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
        fetchWorkTimes(forCurrentMonth: selectedMonth)
    }
    
    func viewRequestedForPreviousMonth() {
        fetchAndChangeSelectedMonth(with: DateComponents(month: -1))
    }
    
    func viewRequestedForNextMonth() {
        fetchAndChangeSelectedMonth(with: DateComponents(month: 1))
    }
    
    func viewRequestedForCellType(at index: IndexPath) -> WorkTimesViewModel.CellType {
        guard dailyWorkTimesArray.count > index.section else { return .standard }
        let workTime = dailyWorkTimesArray[index.section].workTimes.sorted(by: { $0.startsAt > $1.startsAt })[index.row]
        return workTime.taskPreview == nil ? .standard : .taskURL
    }
    
    func viewRequestedForCellModel(at index: IndexPath, cell: WorkTimeCellViewModelOutput) -> WorkTimeCellViewModelType? {
        guard dailyWorkTimesArray.count > index.section else { return nil }
        let workTime = dailyWorkTimesArray[index.section].workTimes.sorted(by: { $0.startsAt > $1.startsAt })[index.row]
        return WorkTimeCellViewModel(workTime: workTime, userInterface: cell)
    }
    
    func viewRequestedForHeaderModel(at section: Int, header: WorkTimesTableViewHeaderViewModelOutput) -> WorkTimesTableViewHeaderViewModelType? {
        guard dailyWorkTimesArray.count > section else { return nil }
        return WorkTimesTableViewHeaderViewModel(userInterface: header, dailyWorkTime: dailyWorkTimesArray[section])
    }
    
    func viewRequestedForNewWorkTimeView(sourceView: UIButton) {
        coordinator.workTimesRequestedForNewWorkTimeView(sourceView: sourceView)
    }
    
    // MARK: - Private
    private func fetchAndChangeSelectedMonth(with components: DateComponents) {
        guard let date = selectedMonth else { return }
        let newComponents = newDateComponents(for: date, oldComponents: components)
        let newSelectedMonth = calendar.date(byAdding: newComponents, to: date)
        selectedMonth = newSelectedMonth
        updateDateSelectorView(withCurrentDate: newSelectedMonth)
        fetchWorkTimes(forCurrentMonth: newSelectedMonth)
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
    
    private func fetchWorkTimes(forCurrentMonth date: Date?) {
        let dates = getStartAndEndDate(for: date)
        let parameters = WorkTimesParameters(fromDate: dates.startOfMonth, toDate: dates.endOfMonth, projectIdentifier: nil)
        
        apiClient.fetchWorkTimes(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let workTimes):
                self?.dailyWorkTimesArray = workTimes.reduce([DailyWorkTime](), { (array, workTime) in
                    var newArray = array
                    if let dailyWorkTimes = newArray.first(where: { $0.day == workTime.date }) {
                        dailyWorkTimes.workTimes.append(workTime)
                    } else {
                        let new = DailyWorkTime(day: workTime.date, workTimes: [workTime])
                        newArray.append(new)
                    }
                    return newArray
                }).sorted(by: { $0.day > $1.day })
                self?.userInterface?.updateView()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    private func getStartAndEndDate(for date: Date?) -> (startOfMonth: Date?, endOfMonth: Date?) {
        guard let date = date else { return (nil, nil) }
        var startOfMonthComponents = calendar.dateComponents([.year, .month], from: date)
        startOfMonthComponents.day = 1
        startOfMonthComponents.timeZone = TimeZone(secondsFromGMT: 0)
        let startOfMonth = calendar.date(from: startOfMonthComponents)
        guard let startDate = startOfMonth else { return (startOfMonth, nil) }
        let endOfMonthComponents = DateComponents(day: -1, hour: 23, minute: 59, second: 59, nanosecond: 59)
        let endOfMonth = calendar.date(byAdding: endOfMonthComponents, to: startDate)
        return (startOfMonth, endOfMonth)
    }
}
