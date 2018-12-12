//
//  WorkTimesViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimesViewModelOutput: class {
    func setUpView(with dateString: String)
    func updateView()
    func updateDateLabel(text: String)
}

protocol WorkTimesViewModelType: class {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func viewDidLoad()
    func viewWillAppear()
    func viewRequestedForPreviousMonth()
    func viewRequestedForNextMonth()
    func viewRequestedForCellModel(at index: IndexPath, cell: WorkTimeCellViewModelOutput) -> WorkTimeCellViewModelType?
    func viewRequestedForHeaderModel(at section: Int, header: WorkTimesTableViewHeaderViewModelOutput) -> WorkTimesTableViewHeaderViewModelType?
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
    private let apiClient: ApiClientWorkTimesType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private var selectedMonth: Date?
    private var dailyWorkTimesArray: [DailyWorkTime]
    
    // MARK: - Initialization
    init(userInterface: WorkTimesViewModelOutput, apiClient: ApiClientWorkTimesType,
         errorHandler: ErrorHandlerType, calendar: CalendarType = Calendar.autoupdatingCurrent) {
        self.userInterface = userInterface
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
        let text = textForDateLabel()
        userInterface?.setUpView(with: text)
    }
    
    func viewWillAppear() {
        fetchWorkTimes()
    }
    
    func viewRequestedForPreviousMonth() {
        fetchAndchangeSelectedMonth(with: DateComponents(month: -1))
    }
    
    func viewRequestedForNextMonth() {
        fetchAndchangeSelectedMonth(with: DateComponents(month: 1))
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
    
    // MARK: - Private
    private func fetchAndchangeSelectedMonth(with components: DateComponents) {
        var newComponents = components
        guard let date = selectedMonth else { return }
        guard let month = calendar.dateComponents([.month], from: date).month else { return }
        if let componentsMonth = components.month {
            if month == 1 && componentsMonth == -1 {
                newComponents.year = -1
            } else if month == 12 && componentsMonth == 1 {
                newComponents.year = 1
            }
        }
        selectedMonth = calendar.date(byAdding: newComponents, to: date)
        fetchWorkTimes()
        let text = textForDateLabel()
        userInterface?.updateDateLabel(text: text)
    }
    
    private func textForDateLabel() -> String {
        guard let date = selectedMonth else { return "" }
        let components = calendar.dateComponents([.month, .year], from: date)
        guard let month = components.month, let year = components.year else { return "" }
        guard let monthSymbol = DateFormatter().shortMonthSymbols?[month - 1] else { return "" }
        return "\(monthSymbol) \(year)"
    }
    
    private func fetchWorkTimes() {
        let dates = getStartAndEndDate(for: selectedMonth)
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
