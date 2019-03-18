//
//  WorkTimeViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 09/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimeViewModelOutput: class {
    func setUp(currentProjectName: String, allowsTask: Bool)
    func dismissView()
    func reloadProjectPicker()
    func dissmissKeyboard()
    func setMinimumDateForTypeEndAtDate(minDate: Date)
    func updateDay(with date: Date, dateString: String)
    func updateStartAtDate(with date: Date, dateString: String)
    func updateEndAtDate(with date: Date, dateString: String)
}

protocol WorkTimeViewModelType: class {
    func viewDidLoad()
    func viewRequestedForNumberOfProjects() -> Int
    func viewRequestedForProjectTitle(atRow row: Int) -> String?
    func viewSelectedProject(atRow row: Int)
    func viewRequestedToFinish()
    func taskNameDidChange(value: String?)
    func setDefaultTask()
    func taskURLDidChange(value: String?)
    func viewChanged(startAtDate date: Date)
    func setDefaultDay()
    func viewChanged(day: Date)
    func setDefaultStartAtDate()
    func viewChanged(endAtDate date: Date)
    func viewRequestedToSave()
    func setDefaultEndAtDate()
    func viewHasBeenTapped()
}

class WorkTimeViewModel: WorkTimeViewModelType {
    private weak var userInterface: WorkTimeViewModelOutput?
    private let apiClient: TimeTableTabApiClientType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private var projects: [ProjectDecoder]
    private var task: Task
    
    // MARK: - Initialization
    
    init(userInterface: WorkTimeViewModelOutput?, apiClient: TimeTableTabApiClientType, errorHandler: ErrorHandlerType, calendar: CalendarType) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.projects = []
        self.task = Task(project: .none, body: "", url: nil, day: Date(), startAt: nil, endAt: nil)
    }
    
    // MARK: - WorkTimeViewModelType
    func viewDidLoad() {
        updateViewWithCurrentSelectedProject()
        fetchProjectList()
    }
    
    func viewRequestedForNumberOfProjects() -> Int {
        return projects.count
    }
    
    func viewRequestedForProjectTitle(atRow row: Int) -> String? {
        return projects.count > row ? projects[row].name : nil
    }
    
    func setDefaultTask() {
        guard !projects.isEmpty else { return }
        switch task.project {
        case .none:
            task.project = .some(projects[0])
            updateViewWithCurrentSelectedProject()
        case .some:
            return
        }
    }
    
    func viewSelectedProject(atRow row: Int) {
        guard projects.count > row else { return }
        task.project = .some(projects[row])
        updateViewWithCurrentSelectedProject()
    }
    
    func viewRequestedToFinish() {
        userInterface?.dismissView()
    }
    
    func taskNameDidChange(value: String?) {
        guard let body = value else { return }
        task.body = body
    }
    
    func taskURLDidChange(value: String?) {
        guard let stringURL = value, let url = URL(string: stringURL) else { return }
        task.url = url
    }
    
    func setDefaultDay() {
        var date = Date()
        if let day = task.day {
            date = day
        }
        task.day = date
        updateDayView(with: date)
    }
    
    func viewChanged(day: Date) {
        task.day = day
        updateDayView(with: day)
    }
    
    func viewChanged(startAtDate date: Date) {
        task.startAt = date
        updateStartAtDateView(with: date)
    }
    
    func setDefaultStartAtDate() {
        var date = Date()
        if let startAt = task.startAt {
            date = startAt
        }
        task.startAt = date
        updateStartAtDateView(with: date)
    }
    
    func viewChanged(endAtDate date: Date) {
        task.endAt = date
        updateEndAtDateView(with: date)
    }
    
    func setDefaultEndAtDate() {
        var date =  Date()
        if let toDate = task.endAt {
            date = toDate
        } else {
            date = task.startAt ?? Date()
            task.endAt = date
        }
        updateEndAtDateView(with: date)
    }
    
    func viewRequestedToSave() {
        do {
            try validateInputs()
            apiClient.addWorkTime(parameters: task) { [weak self] result in
                switch result {
                case .success:
                    self?.userInterface?.dismissView()
                case .failure(let error):
                    self?.errorHandler.throwing(error: error)
                }
            }
        } catch {
            self.errorHandler.throwing(error: error)
        }
    }
    
    func viewHasBeenTapped() {
        userInterface?.dissmissKeyboard()
    }
    
    // MARK: - Private
    private func validateInputs() throws {
        guard .none != task.project else { throw UIError.cannotBeEmpty(.projectTextField) }
        guard !task.body.isEmpty || (task.allowsTask && task.url != nil) else { throw UIError.cannotBeEmptyOr(.taskNameTextField, .taskUrlTextField) }
        guard let fromDate = task.startAt else { throw UIError.cannotBeEmpty(.startsAtTextField) }
        guard let toDate = task.endAt else { throw UIError.cannotBeEmpty(.endsAtTextField) }
        guard fromDate < toDate else { throw UIError.timeGreaterThan }
    }
    
    private func updateViewWithCurrentSelectedProject() {
        userInterface?.setUp(currentProjectName: task.title, allowsTask: task.allowsTask)
        
        guard let type = task.type else { return }
        switch type {
        case .fullDay(let timeInterval):
            let fromDate = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
            let toDate = fromDate.addingTimeInterval(timeInterval)
            task.startAt = fromDate
            task.endAt = toDate
            updateStartAtDateView(with: fromDate)
            updateEndAtDateView(with: toDate)
        case .lunch(let timeInterval):
            let fromDate = task.startAt ?? calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
            let toDate = fromDate.addingTimeInterval(timeInterval)
            task.startAt = fromDate
            task.endAt = toDate
            updateStartAtDateView(with: fromDate)
            updateEndAtDateView(with: toDate)
        case .standard: break
        }
    }
    
    private func updateDayView(with date: Date) {
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        userInterface?.updateDay(with: date, dateString: dateString)
    }
    
    private func updateStartAtDateView(with date: Date) {
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        userInterface?.updateStartAtDate(with: date, dateString: dateString)
        userInterface?.setMinimumDateForTypeEndAtDate(minDate: date)
        if let startAt = task.endAt, startAt < date {
            task.endAt = date
            updateEndAtDateView(with: date)
        }
    }
    
    private func updateEndAtDateView(with date: Date) {
        userInterface?.updateEndAtDate(with: date, dateString: DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short))
    }
    
    private func fetchProjectList() {
        apiClient.fetchSimpleListOfProjects { [weak self] result in
            switch result {
            case .success(let projects):
                self?.projects = projects.filter { $0.isActive ?? false }
                self?.userInterface?.reloadProjectPicker()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
}
