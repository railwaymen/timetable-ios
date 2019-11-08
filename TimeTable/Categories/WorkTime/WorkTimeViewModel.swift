//
//  WorkTimeViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 09/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimeViewModelOutput: class {
    func setUp(isLunch: Bool, allowsTask: Bool, body: String?, urlString: String?)
    func dismissView()
    func reloadTagsView()
    func dismissKeyboard()
    func setMinimumDateForTypeEndAtDate(minDate: Date)
    func updateDay(with date: Date, dateString: String)
    func updateStartAtDate(with date: Date, dateString: String)
    func updateEndAtDate(with date: Date, dateString: String)
    func updateProject(name: String)
    func setActivityIndicator(isHidden: Bool)
}

protocol WorkTimeViewModelType: class {
    func viewDidLoad()
    func projectButtonTapped()
    func viewRequestedForNumberOfTags() -> Int
    func viewRequestedForTag(at index: IndexPath) -> ProjectTag?
    func viewSelectedTag(at index: IndexPath)
    func isTagSelected(at index: IndexPath) -> Bool
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
    private weak var coordinator: WorkTimeCoordinatorType?
    private let apiClient: WorkTimeApiClientType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private let lastTask: Task?
    private var projects: [ProjectDecoder]
    private var task: Task
    private var tags: [ProjectTag]
    
    private lazy var addUpdateCompletionHandler: (Result<Void>) -> Void = { [weak self] result in
        self?.userInterface?.setActivityIndicator(isHidden: true)
        switch result {
        case .success:
            self?.userInterface?.dismissView()
            self?.coordinator?.viewDidFinish(isTaskChanged: true)
        case .failure(let error):
            self?.errorHandler.throwing(error: error)
        }
    }
    
    // MARK: - Initialization
    init(userInterface: WorkTimeViewModelOutput?,
         coordinator: WorkTimeCoordinatorType?,
         apiClient: WorkTimeApiClientType,
         errorHandler: ErrorHandlerType,
         calendar: CalendarType,
         flowType: FlowType) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.calendar = calendar
        let lastTaskValidation: (Task?) -> Task? = { lastTask in
            guard let lastTaskEndAt = lastTask?.endAt, calendar.isDateInToday(lastTaskEndAt) else { return nil }
            return lastTask
        }
        let taskCreation: (_ duplicatedTask: Task?, _ lastTask: Task?) -> Task = { duplicatedTask, lastTask in
            return Task(
                workTimeIdentifier: nil,
                project: duplicatedTask?.project,
                body: duplicatedTask?.body ?? "",
                url: duplicatedTask?.url,
                day: Date(),
                startAt: lastTask?.endAt,
                endAt: nil,
                tag: duplicatedTask?.tag ?? .default)
        }
        switch flowType {
        case let .newEntry(lastTask):
            self.lastTask = lastTaskValidation(lastTask)
            self.task = taskCreation(nil, lastTask)
        case let .duplicateEntry(duplicatedTask, lastTask):
            self.lastTask = lastTaskValidation(lastTask)
            self.task = taskCreation(duplicatedTask, lastTask)
        case let .editEntry(editedTask):
            self.task = editedTask
            self.lastTask = nil
        }
        self.projects = []
        self.tags = []
    }
    
    // MARK: - WorkTimeViewModelType
    func viewDidLoad() {
        setDefaultDay()
        updateViewWithCurrentSelectedProject()
        fetchProjectList()
    }
    
    func projectButtonTapped() {
        coordinator?.showProjectPicker(projects: projects) { [weak self] project in
            guard project != nil else { return }
            self?.task.project = project
            self?.updateViewWithCurrentSelectedProject()
        }
    }
    
    func viewRequestedForNumberOfTags() -> Int {
        return self.tags.count
    }
    
    func viewRequestedForTag(at index: IndexPath) -> ProjectTag? {
        return self.tags.count > index.row ? self.tags[index.row] : nil
    }
    
    func isTagSelected(at index: IndexPath) -> Bool {
        guard self.tags.count > index.row else { return false }
        return self.tags[index.row] == self.task.tag
    }
    
    func setDefaultTask() {
        guard !projects.isEmpty else { return }
        switch task.project {
        case .none:
            if let lastProject = lastTask?.project {
                task.project = .some(lastProject)
            } else {
                task.project = .some(projects[0])
            }
        case .some:
            break
        }
        updateViewWithCurrentSelectedProject()
    }
    
    func viewSelectedTag(at index: IndexPath) {
        guard self.tags.count > index.row else { return }
        let selectedTag = self.tags[index.row]
        self.task.tag = self.task.tag == selectedTag ? .development : selectedTag
        self.userInterface?.reloadTagsView()
    }
    
    func viewRequestedToFinish() {
        self.userInterface?.dismissView()
        self.coordinator?.viewDidFinish(isTaskChanged: false)
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
        let date = task.day ?? Date()
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
        let date = task.startAt ?? Date()
        task.startAt = date
        updateStartAtDateView(with: date)
    }
    
    func viewChanged(endAtDate date: Date) {
        task.endAt = date
        updateEndAtDateView(with: date)
    }
    
    func setDefaultEndAtDate() {
        let date: Date
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
            userInterface?.setActivityIndicator(isHidden: false)
            if let workTimeIdentifier = task.workTimeIdentifier {
                apiClient.updateWorkTime(identifier: workTimeIdentifier, parameters: task, completion: self.addUpdateCompletionHandler)
            } else {
                apiClient.addWorkTime(parameters: task, completion: self.addUpdateCompletionHandler)
            }
        } catch {
            errorHandler.throwing(error: error)
        }
    }
    
    func viewHasBeenTapped() {
        userInterface?.dismissKeyboard()
    }
    
    // MARK: - Private
    private func validateInputs() throws {
        guard let project = task.project else { throw UIError.cannotBeEmpty(.projectTextField) }
        guard !task.body.isEmpty || (task.allowsTask && task.url != nil) || project.isLunch
            else { throw UIError.cannotBeEmptyOr(.taskNameTextField, .taskUrlTextField) }
        guard let fromDate = task.startAt else { throw UIError.cannotBeEmpty(.startsAtTextField) }
        guard let toDate = task.endAt else { throw UIError.cannotBeEmpty(.endsAtTextField) }
        guard fromDate < toDate else { throw UIError.timeGreaterThan }
    }
    
    private func updateViewWithCurrentSelectedProject() {
        userInterface?.setUp(isLunch: task.project?.isLunch ?? false,
                             allowsTask: task.allowsTask,
                             body: task.body,
                             urlString: task.url?.absoluteString)
        
        let fromDate: Date
        let toDate: Date
        switch task.type {
        case .fullDay(let timeInterval)?:
            fromDate = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
            toDate = fromDate.addingTimeInterval(timeInterval)
            task.startAt = fromDate
            task.endAt = toDate
        case .lunch(let timeInterval)?:
            fromDate = task.startAt ?? Date()
            toDate = fromDate.addingTimeInterval(timeInterval)
            task.startAt = fromDate
            task.endAt = toDate
        case .standard?, .none:
            fromDate = lastTask?.endAt ?? task.startAt ?? Date()
            toDate = task.endAt ?? fromDate
            task.startAt = fromDate
            task.endAt = toDate
            setDefaultStartAtDate()
            setDefaultEndAtDate()
        }
        updateStartAtDateView(with: fromDate)
        updateEndAtDateView(with: toDate)
        userInterface?.updateProject(name: task.project?.name ?? "work_time.text_field.select_project".localized)
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
        userInterface?.setActivityIndicator(isHidden: false)
        apiClient.fetchSimpleListOfProjects { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .success(let simpleProjectDecoder):
                self?.projects = simpleProjectDecoder.projects.filter { $0.isActive ?? false }
                self?.tags = simpleProjectDecoder.tags.filter { $0 != .default }
                self?.userInterface?.reloadTagsView()
                self?.setDefaultTask()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
}

// MARK: - Structures
extension WorkTimeViewModel {
    enum FlowType {
        case newEntry(lastTask: Task?)
        case editEntry(editedTask: Task)
        case duplicateEntry(duplicatedTask: Task, lastTask: Task?)
    }
    
}

extension WorkTimeViewModel.FlowType: Equatable {
    static func == (lhs: WorkTimeViewModel.FlowType, rhs: WorkTimeViewModel.FlowType) -> Bool {
        switch (lhs, rhs) {
        case let (.newEntry(lhsLastTask), .newEntry(rhsLastTask)):
            return lhsLastTask == rhsLastTask
        case let (.editEntry(lhsEditedTask), .editEntry(rhsEditedTask)):
            return lhsEditedTask == rhsEditedTask
        case let (.duplicateEntry(lhsDuplicatedTask, lhsLastTask), .duplicateEntry(rhsDuplicatedTask, rhsLastTask)):
            return lhsLastTask == rhsLastTask && lhsDuplicatedTask == rhsDuplicatedTask
        default:
            return false
        }
    }
}
