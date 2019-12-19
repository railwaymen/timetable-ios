//
//  WorkTimeViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 09/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol WorkTimeViewModelOutput: class {
    func setUp(title: String, isLunch: Bool, allowsTask: Bool, body: String?, urlString: String?)
    func dismissView()
    func reloadTagsView()
    func dismissKeyboard()
    func setMinimumDateForTypeEndAtDate(minDate: Date)
    func updateDay(with date: Date, dateString: String)
    func updateStartAtDate(with date: Date, dateString: String)
    func updateEndAtDate(with date: Date, dateString: String)
    func updateProject(name: String)
    func setActivityIndicator(isHidden: Bool)
    func setBottomContentInset(_ height: CGFloat)
    func setTagsCollectionView(isHidden: Bool)
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

class WorkTimeViewModel {
    private weak var userInterface: WorkTimeViewModelOutput?
    private weak var coordinator: WorkTimeCoordinatorType?
    private let apiClient: WorkTimeApiClientType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private let notificationCenter: NotificationCenterType
    private let lastTask: Task?
    private let viewTitle: String
    private var projects: [ProjectDecoder]
    private var task: Task
    private var tags: [ProjectTag]
    
    private lazy var addUpdateCompletionHandler: (Result<Void, Error>) -> Void = { [weak self] result in
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
    init(
        userInterface: WorkTimeViewModelOutput?,
        coordinator: WorkTimeCoordinatorType?,
        apiClient: WorkTimeApiClientType,
        errorHandler: ErrorHandlerType,
        calendar: CalendarType,
        notificationCenter: NotificationCenterType,
        flowType: FlowType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.notificationCenter = notificationCenter
        self.viewTitle = flowType.viewTitle
        let lastTaskValidation: (Task?) -> Task? = { lastTask in
            guard let lastTaskEndAt = lastTask?.endsAt, calendar.isDateInToday(lastTaskEndAt) else { return nil }
            return lastTask
        }
        let taskCreation: (_ duplicatedTask: Task?, _ lastTask: Task?) -> Task = { duplicatedTask, lastTask in
            return Task(
                workTimeIdentifier: nil,
                project: duplicatedTask?.project,
                body: duplicatedTask?.body ?? "",
                url: duplicatedTask?.url,
                day: Date(),
                startsAt: lastTask?.endsAt,
                endsAt: nil,
                tag: duplicatedTask?.tag ?? .default)
        }
        switch flowType {
        case let .newEntry(lastTask):
            self.lastTask = lastTaskValidation(lastTask)
            self.task = taskCreation(nil, lastTaskValidation(lastTask))
        case let .duplicateEntry(duplicatedTask, lastTask):
            self.lastTask = lastTaskValidation(lastTask)
            self.task = taskCreation(duplicatedTask, lastTask)
        case let .editEntry(editedTask):
            self.task = editedTask
            self.lastTask = nil
        }
        self.projects = []
        self.tags = []
        
        self.setUpNotification()
    }
    
    // MARK: - Notifications
    @objc func keyboardFrameWillChange(_ notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        self.userInterface?.setBottomContentInset(keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        self.userInterface?.setBottomContentInset(0)
    }
}

// MARK: - Structures
extension WorkTimeViewModel {
    enum FlowType {
        case newEntry(lastTask: Task?)
        case editEntry(editedTask: Task)
        case duplicateEntry(duplicatedTask: Task, lastTask: Task?)
        
        var viewTitle: String {
            switch self {
            case .editEntry: return "work_time.title.edit".localized
            case .newEntry, .duplicateEntry: return "work_time.title.new".localized
            }
        }
    }
}

// MARK: - WorkTimeViewModelType
extension WorkTimeViewModel: WorkTimeViewModelType {
    func viewDidLoad() {
        self.setDefaultDay()
        self.updateViewWithCurrentSelectedProject()
        self.fetchProjectList()
    }
    
    func projectButtonTapped() {
        self.coordinator?.showProjectPicker(projects: self.projects) { [weak self] project in
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
        guard !self.projects.isEmpty else { return }
        if self.task.project == nil {
            self.task.project = .some(self.lastTask?.project ?? self.projects[0])
        }
        self.updateViewWithCurrentSelectedProject()
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
        self.task.body = body
    }
    
    func taskURLDidChange(value: String?) {
        guard let stringURL = value, let url = URL(string: stringURL) else { return }
        self.task.url = url
    }
    
    func setDefaultDay() {
        let date = self.task.day ?? Date()
        self.task.day = date
        self.updateDayView(with: date)
    }
    
    func viewChanged(day: Date) {
        self.task.day = day
        self.updateDayView(with: day)
    }
    
    func viewChanged(startAtDate date: Date) {
        self.task.startsAt = date
        self.updateStartAtDateView(with: date)
    }
    
    func setDefaultStartAtDate() {
        let date = self.task.startsAt ?? Date().roundedToFiveMinutes()
        self.task.startsAt = date
        self.updateStartAtDateView(with: date)
    }
    
    func viewChanged(endAtDate date: Date) {
        self.task.endsAt = date
        self.updateEndAtDateView(with: date)
    }
    
    func setDefaultEndAtDate() {
        let date: Date
        if let toDate = self.task.endsAt {
            date = toDate
        } else {
            date = self.task.startsAt ?? Date().roundedToFiveMinutes()
            self.task.endsAt = date
        }
        self.updateEndAtDateView(with: date)
    }
    
    func viewRequestedToSave() {
        do {
            try self.validateInputs()
            self.userInterface?.setActivityIndicator(isHidden: false)
            if let workTimeIdentifier = self.task.workTimeIdentifier {
                self.apiClient.updateWorkTime(identifier: workTimeIdentifier, parameters: self.task, completion: self.addUpdateCompletionHandler)
            } else {
                self.apiClient.addWorkTime(parameters: self.task, completion: self.addUpdateCompletionHandler)
            }
        } catch {
            self.errorHandler.throwing(error: error)
        }
    }
    
    func viewHasBeenTapped() {
        self.userInterface?.dismissKeyboard()
    }
}

// MARK: - Equatable
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

// MARK: - Private
extension WorkTimeViewModel {
    private func setUpNotification() {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardFrameWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func validateInputs() throws {
        do {
            try self.task.validate()
        } catch let error as TaskValidationError {
            switch error {
            case .projectIsNil:
                throw UIError.cannotBeEmpty(.projectTextField)
            case .urlIsNil:
                throw UIError.cannotBeEmpty(.taskUrlTextField)
            case .bodyIsEmpty:
                throw UIError.cannotBeEmpty(.taskNameTextField)
            case .startsAtIsNil:
                throw UIError.cannotBeEmpty(.startsAtTextField)
            case .endsAtIsNil:
                throw UIError.cannotBeEmpty(.endsAtTextField)
            case .timeRangeIsIncorrect:
                throw UIError.timeGreaterThan
            }
        } catch {
            assertionFailure()
        }
//        guard let project = self.task.project else { throw UIError.cannotBeEmpty(.projectTextField) }
//        guard !self.task.body.isEmpty || (self.task.allowsTask && self.task.url != nil) || project.isLunch || !(project.countDuration ?? false)
//            else { throw UIError.cannotBeEmptyOr(.taskNameTextField, .taskUrlTextField) }
//        guard let fromDate = self.task.startsAt else { throw UIError.cannotBeEmpty(.startsAtTextField) }
//        guard let toDate = self.task.endsAt else { throw UIError.cannotBeEmpty(.endsAtTextField) }
//        guard fromDate < toDate else { throw UIError.timeGreaterThan }
    }
    
    private func updateViewWithCurrentSelectedProject() {
        self.userInterface?.setUp(
            title: self.viewTitle,
            isLunch: self.task.project?.isLunch ?? false,
            allowsTask: self.task.allowsTask,
            body: self.task.body,
            urlString: self.task.url?.absoluteString)
        self.userInterface?.setTagsCollectionView(isHidden: !self.task.isTaggable)
        let fromDate: Date
        let toDate: Date
        switch self.task.type {
        case .fullDay(let timeInterval)?:
            fromDate = self.calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
            toDate = fromDate.addingTimeInterval(timeInterval)
            self.task.startsAt = fromDate
            self.task.endsAt = toDate
        case .lunch(let timeInterval)?:
            fromDate = self.task.startsAt ?? Date().roundedToFiveMinutes()
            toDate = fromDate.addingTimeInterval(timeInterval)
            self.task.startsAt = fromDate
            self.task.endsAt = toDate
        case .standard?, .none:
            fromDate = self.lastTask?.endsAt ?? self.task.startsAt ?? Date().roundedToFiveMinutes()
            toDate = self.task.endsAt ?? fromDate
            self.task.startsAt = fromDate
            self.task.endsAt = toDate
            self.setDefaultStartAtDate()
            self.setDefaultEndAtDate()
        }
        self.updateStartAtDateView(with: fromDate)
        self.updateEndAtDateView(with: toDate)
        self.userInterface?.updateProject(name: self.task.project?.name ?? "work_time.text_field.select_project".localized)
    }
    
    private func updateDayView(with date: Date) {
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        self.userInterface?.updateDay(with: date, dateString: dateString)
    }
    
    private func updateStartAtDateView(with date: Date) {
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        self.userInterface?.updateStartAtDate(with: date, dateString: dateString)
        self.userInterface?.setMinimumDateForTypeEndAtDate(minDate: date)
        if let startAt = self.task.endsAt, startAt < date {
            self.task.endsAt = date
            self.updateEndAtDateView(with: date)
        }
    }
    
    private func updateEndAtDateView(with date: Date) {
        self.userInterface?.updateEndAtDate(with: date, dateString: DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short))
    }
    
    private func fetchProjectList() {
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.apiClient.fetchSimpleListOfProjects { [weak self] result in
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
