//
//  WorkTimesViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimesViewModelOutput: class {
    func setUpView()
    func updateView()
}

protocol WorkTimesViewModelType: class {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func viewDidLoad()
    func viewWillAppear()
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
    
    private var dailyWorkTimesArray: [DailyWorkTime]
    
    // MARK: - Initialization
    init(userInterface: WorkTimesViewModelOutput, apiClient: ApiClientWorkTimesType,
         errorHandler: ErrorHandlerType, calendar: CalendarType = Calendar.autoupdatingCurrent) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.dailyWorkTimesArray = []
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
    }
    
    func viewWillAppear() {
        let dates = getStartAndEndDate(for: Date())
        let parameters = WorkTimesParameters(fromDate: dates.startOfMonth, toDate: dates.endOfMonth, projectIdentifier: nil)
        fetchWorkTimes(for: parameters)
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
    private func fetchWorkTimes(for parameters: WorkTimesParameters) {
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
    
    private func getStartAndEndDate(for date: Date) -> (startOfMonth: Date?, endOfMonth: Date?) {
        var startOfMonthComponents = calendar.dateComponents([.year, .month], from: date)
        startOfMonthComponents.day = 1
        let startOfMonth = calendar.date(from: startOfMonthComponents)
        guard let date = startOfMonth else { return (startOfMonth, nil) }
        let endOfMonthComponents = DateComponents(month: 1)
        let endOfMonth = calendar.date(byAdding: endOfMonthComponents, to: date)
        return (startOfMonth, endOfMonth)
    }
}
