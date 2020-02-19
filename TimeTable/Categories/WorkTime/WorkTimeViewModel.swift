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
    func taskURLDidChange(value: String?)
    func viewChanged(startAtDate date: Date)
    func viewChanged(day: Date)
    func viewChanged(endAtDate date: Date)
    func viewRequestedToSave()
    func viewHasBeenTapped()
}

class WorkTimeViewModel {
    private weak var userInterface: WorkTimeViewModelOutput?
    private weak var coordinator: WorkTimeCoordinatorType?
    private let contentProvider: WorkTimeContentProviderType
    private let apiClient: WorkTimeApiClientType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private let notificationCenter: NotificationCenterType
    private let lastTask: Task?
    private let viewTitle: String
    private var projects: [ProjectDecoder]
    private var task: Task
    private var tags: [ProjectTag]
    
    // MARK: - Initialization
    init(
        userInterface: WorkTimeViewModelOutput?,
        coordinator: WorkTimeCoordinatorType?,
        contentProvider: WorkTimeContentProviderType,
        apiClient: WorkTimeApiClientType,
        errorHandler: ErrorHandlerType,
        calendar: CalendarType,
        notificationCenter: NotificationCenterType,
        flowType: FlowType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.notificationCenter = notificationCenter
        self.viewTitle = flowType.viewTitle
        let taskCreation: (_ duplicatedTask: Task?, _ lastTask: Task?) -> Task = { duplicatedTask, lastTask in
            return Task(
                workTimeIdentifier: nil,
                project: duplicatedTask?.project,
                body: duplicatedTask?.body ?? "",
                url: duplicatedTask?.url,
                day: Date(),
                startsAt: contentProvider.pickEndTime(ofLastTask: lastTask),
                endsAt: nil,
                tag: duplicatedTask?.tag ?? .default)
        }
        switch flowType {
        case let .newEntry(lastTask):
            self.lastTask = lastTask
            self.task = taskCreation(nil, lastTask)
        case let .duplicateEntry(duplicatedTask, lastTask):
            self.lastTask = lastTask
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
    enum FlowType: Equatable {
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
        return self.tags[safeIndex: index.row]
    }
    
    func isTagSelected(at index: IndexPath) -> Bool {
        return self.tags[safeIndex: index.row] == self.task.tag
    }
    
    func viewSelectedTag(at index: IndexPath) {
        guard let selectedTag = self.tags[safeIndex: index.row] else { return }
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
    
    func viewChanged(day: Date) {
        self.task.day = day
        self.updateDayView(with: day)
    }
    
    func viewChanged(startAtDate date: Date) {
        self.task.startsAt = date
        self.updateStartAtDateView(with: date)
    }
    
    func viewChanged(endAtDate date: Date) {
        self.task.endsAt = date
        self.updateEndAtDateView(with: date)
    }
    
    func viewRequestedToSave() {
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.contentProvider.save(task: self.task) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .success:
                self?.userInterface?.dismissView()
                self?.coordinator?.viewDidFinish(isTaskChanged: true)
            case let .failure(error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    func viewHasBeenTapped() {
        self.userInterface?.dismissKeyboard()
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
    
    private func setDefaultTask() {
        guard let defaultProject = self.projects.first(where: { $0 == self.lastTask?.project }) ?? self.projects.first else { return }
        if self.task.project == nil {
            self.task.project = .some(self.lastTask?.project ?? defaultProject)
        }
        self.updateViewWithCurrentSelectedProject()
    }
    
    private func setDefaultDay() {
        let date = self.contentProvider.getDefaultDay(forTask: self.task)
        self.task.day = date
        self.updateDayView(with: date)
    }
    
    private func updateViewWithCurrentSelectedProject() {
        let (startDate, endDate) = self.contentProvider.getDefaultTime(forTask: self.task, lastTask: self.lastTask)
        self.task.startsAt = startDate
        self.task.endsAt = endDate
        self.userInterface?.setUp(
            title: self.viewTitle,
            isLunch: self.task.project?.isLunch ?? false,
            allowsTask: self.task.allowsTask,
            body: self.task.body,
            urlString: self.task.url?.absoluteString)
        self.userInterface?.setTagsCollectionView(isHidden: !self.task.isProjectTaggable)
        self.updateStartAtDateView(with: startDate)
        self.updateEndAtDateView(with: endDate)
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
        if let endsAt = self.task.endsAt, endsAt < date {
            self.task.endsAt = date
            self.updateEndAtDateView(with: date)
        }
    }
    
    private func updateEndAtDateView(with date: Date) {
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        self.userInterface?.updateEndAtDate(with: date, dateString: dateString)
    }
    
    private func fetchProjectList() {
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.contentProvider.fetchSimpleProjectsList { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case let .success((projects, tags)):
                self?.projects = projects
                self?.tags = tags
                self?.userInterface?.reloadTagsView()
                self?.setDefaultTask()
            case let .failure(error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
}
