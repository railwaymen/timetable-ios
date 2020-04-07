//
//  WorkTimeViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 09/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol WorkTimeViewModelOutput: class {
    func setUp()
    func setBodyView(isHidden: Bool)
    func setTaskURLView(isHidden: Bool)
    func setBody(text: String)
    func setTask(urlString: String)
    func setSaveWithFillingButton(isHidden: Bool)
    func setSaveButtons(isEnabled: Bool)
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
    
    func setProject(isHighlighted: Bool)
    func setDay(isHighlighted: Bool)
    func setStartsAt(isHighlighted: Bool)
    func setEndsAt(isHighlighted: Bool)
    func setBody(isHighlighted: Bool)
    func setTaskURL(isHighlighted: Bool)
}

protocol WorkTimeViewModelType: class {
    func viewDidLoad()
    func configure(_ cell: TagCollectionViewCellable, for indexPath: IndexPath)
    func projectButtonTapped()
    func viewRequestedForNumberOfTags() -> Int
    func viewRequestedForTag(at index: IndexPath) -> ProjectTag?
    func viewSelectedTag(at index: IndexPath)
    func isTagSelected(at index: IndexPath) -> Bool
    func taskNameDidChange(value: String?)
    func taskURLDidChange(value: String?)
    func viewChanged(startAtDate date: Date)
    func viewChanged(day: Date)
    func viewChanged(endAtDate date: Date)
    func viewRequestedToSave()
    func viewRequestedToSaveWithFilling()
    func viewHasBeenTapped()
}

class WorkTimeViewModel {
    private weak var userInterface: WorkTimeViewModelOutput?
    private weak var coordinator: WorkTimeCoordinatorType?
    private let contentProvider: WorkTimeContentProviderType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private let notificationCenter: NotificationCenterType
    private let lastTask: TaskForm?
    private let flowType: FlowType
    
    private var projects: [SimpleProjectRecordDecoder]
    private var taskForm: TaskFormType {
        didSet {
            self.updateValidationErrorsOnUI()
        }
    }
    private var tags: [ProjectTag]
    
    // MARK: - Initialization
    init(
        userInterface: WorkTimeViewModelOutput?,
        coordinator: WorkTimeCoordinatorType?,
        contentProvider: WorkTimeContentProviderType,
        errorHandler: ErrorHandlerType,
        calendar: CalendarType,
        notificationCenter: NotificationCenterType,
        flowType: FlowType,
        taskFormFactory: TaskFormFactoryType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.notificationCenter = notificationCenter
        self.flowType = flowType
        
        switch flowType {
        case let .newEntry(lastTask):
            self.lastTask = lastTask
            self.taskForm = taskFormFactory.buildTaskForm(duplicatedTask: nil, lastTask: lastTask)
        case let .duplicateEntry(duplicatedTask, lastTask):
            self.lastTask = lastTask
            self.taskForm = taskFormFactory.buildTaskForm(duplicatedTask: duplicatedTask, lastTask: lastTask)
        case let .editEntry(editedTask):
            self.taskForm = editedTask
            self.lastTask = nil
        }
        self.projects = []
        self.tags = []
        
        self.setUpNotification()
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc func keyboardFrameWillChange(_ notification: NSNotification) {
        let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight = userInfo?.cgRectValue.size.height else { return }
        self.userInterface?.setBottomContentInset(keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        self.userInterface?.setBottomContentInset(0)
    }
}

// MARK: - Structures
extension WorkTimeViewModel {
    enum FlowType: Equatable {
        case newEntry(lastTask: TaskForm?)
        case editEntry(editedTask: TaskForm)
        case duplicateEntry(duplicatedTask: TaskForm, lastTask: TaskForm?)
        
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
        self.setUpUI()
    }
    
    func configure(_ cell: TagCollectionViewCellable, for indexPath: IndexPath) {
        guard let tag = self.viewRequestedForTag(at: indexPath) else { return }
        let viewModel = TagCollectionViewCellModel(
            userInterface: cell,
            projectTag: tag,
            isSelected: self.isTagSelected(at: indexPath))
        cell.configure(viewModel: viewModel)
    }
    
    func projectButtonTapped() {
        self.coordinator?.showProjectPicker(projects: self.projects) { [weak self] project in
            guard project != nil else { return }
            self?.taskForm.project = project
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
        return self.tags[safeIndex: index.row] == self.taskForm.tag
    }
    
    func viewSelectedTag(at index: IndexPath) {
        guard let selectedTag = self.tags[safeIndex: index.row] else { return }
        self.taskForm.tag = self.taskForm.tag == selectedTag ? .development : selectedTag
        self.userInterface?.reloadTagsView()
    }
    
    func taskNameDidChange(value: String?) {
        self.taskForm.body = value ?? ""
    }
    
    func taskURLDidChange(value: String?) {
        self.taskForm.urlString = value ?? ""
    }
    
    func viewChanged(day: Date) {
        self.taskForm.day = day
        self.updateDayView(with: day)
    }
    
    func viewChanged(startAtDate date: Date) {
        self.taskForm.startsAt = date
        self.updateStartAtDateView(with: date)
    }
    
    func viewChanged(endAtDate date: Date) {
        self.taskForm.endsAt = date
        self.updateEndAtDateView(with: date)
    }
    
    func viewRequestedToSave() {
        self.saveTask(withFilling: false)
    }
    
    func viewRequestedToSaveWithFilling() {
        self.saveTask(withFilling: true)
    }
    
    func viewHasBeenTapped() {
        self.userInterface?.dismissKeyboard()
    }
}

// MARK: - WorkTimeContainerContentType
extension WorkTimeViewModel: WorkTimeContainerContentType {
    func containerDidUpdate(projects: [SimpleProjectRecordDecoder], tags: [ProjectTag]) {
        self.projects = projects
        self.tags = tags
        self.userInterface?.reloadTagsView()
        self.setDefaultTask()
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
    
    private func setUpUI() {
        self.userInterface?.setUp()
        switch self.flowType {
        case .editEntry:
            self.userInterface?.setSaveWithFillingButton(isHidden: true)
        case .newEntry, .duplicateEntry:
            self.userInterface?.setSaveWithFillingButton(isHidden: false)
        }
        self.updateViewWithCurrentSelectedProject()
    }
    
    private func setDefaultTask() {
        let lastTaskProject = self.projects.first(where: { $0 == self.lastTask?.project })
        guard let defaultProject = lastTaskProject ?? self.projects.first else { return }
        if self.taskForm.project == nil {
            self.taskForm.project = .some(self.lastTask?.project ?? defaultProject)
        }
        self.updateViewWithCurrentSelectedProject()
    }
    
    private func setDefaultDay() {
        let date = self.contentProvider.getPredefinedDay(forTaskForm: self.taskForm)
        self.taskForm.day = date
        self.updateDayView(with: date)
    }
    
    private func updateViewWithCurrentSelectedProject() {
        let (startDate, endDate) = self.contentProvider.getPredefinedTimeBounds(
            forTaskForm: self.taskForm,
            lastTask: self.lastTask)
        self.taskForm.startsAt = startDate
        self.taskForm.endsAt = endDate
        let isLunch = self.taskForm.project?.isLunch ?? false
        self.userInterface?.setBodyView(isHidden: isLunch)
        self.userInterface?.setTaskURLView(isHidden: !self.taskForm.allowsTask || isLunch)
        self.userInterface?.setBody(text: self.taskForm.body)
        self.userInterface?.setTask(urlString: self.taskForm.urlString ?? "")
        self.userInterface?.setTagsCollectionView(isHidden: !self.taskForm.isProjectTaggable)
        self.updateEndAtDateView(with: endDate)
        self.updateStartAtDateView(with: startDate)
        self.userInterface?.updateProject(name: self.taskForm.project?.name ?? "work_time.text_field.select_project".localized)
    }
    
    private func updateDayView(with date: Date) {
        let dateString = DateFormatter.shortDate.string(from: date)
        self.userInterface?.updateDay(with: date, dateString: dateString)
    }
    
    private func updateStartAtDateView(with date: Date) {
        let dateString = DateFormatter.shortTime.string(from: date)
        self.userInterface?.updateStartAtDate(with: date, dateString: dateString)
        self.userInterface?.setMinimumDateForTypeEndAtDate(minDate: date)
        if let endsAt = self.taskForm.endsAt, endsAt < date {
            self.taskForm.endsAt = date
            self.updateEndAtDateView(with: date)
        }
    }
    
    private func updateEndAtDateView(with date: Date) {
        let dateString = DateFormatter.shortTime.string(from: date)
        self.userInterface?.updateEndAtDate(with: date, dateString: dateString)
    }
    
    private func saveTask(withFilling: Bool) {
        let completion: WorkTimeSaveTaskCompletion = self.getSaveCompletion()
        self.userInterface?.setSaveButtons(isEnabled: false)
        self.userInterface?.setActivityIndicator(isHidden: false)
        withFilling
            ? self.contentProvider.saveWithFilling(taskForm: self.taskForm, completion: completion)
            : self.contentProvider.save(taskForm: self.taskForm, completion: completion)
    }
    
    private func getSaveCompletion() -> WorkTimeSaveTaskCompletion {
        return { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .success:
                self?.coordinator?.dismissView(isTaskChanged: true)
            case let .failure(error):
                self?.userInterface?.setSaveButtons(isEnabled: true)
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    private func updateValidationErrorsOnUI() {
        let errors = self.contentProvider.getValidationErrors(forTaskForm: self.taskForm)
        self.userInterface?.setSaveButtons(isEnabled: errors.isEmpty)
        self.userInterface?.setProject(isHighlighted: errors.contains(.cannotBeEmpty(.projectTextField)))
        self.userInterface?.setDay(isHighlighted: errors.contains(.cannotBeEmpty(.dayTextField)))
        self.userInterface?.setStartsAt(
            isHighlighted: errors.contains(.cannotBeEmpty(.startsAtTextField)) || errors.contains(.timeGreaterThan))
        self.userInterface?.setEndsAt(
            isHighlighted: errors.contains(.cannotBeEmpty(.endsAtTextField)) || errors.contains(.timeGreaterThan))
        self.userInterface?.setBody(isHighlighted: errors.contains(.cannotBeEmpty(.taskNameTextField)))
        self.userInterface?.setTaskURL(isHighlighted: errors.contains(.cannotBeEmpty(.taskUrlTextField)))
    }
}
