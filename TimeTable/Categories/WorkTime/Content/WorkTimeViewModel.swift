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
    func updateColors()
    func setBodyView(isHidden: Bool)
    func setTaskURLView(isHidden: Bool)
    func setBody(text: String)
    func setTask(urlString: String)
    func setSaveWithFilling(isHidden: Bool)
    func setSaveWithFilling(isChecked: Bool)
    func setSaveButton(isEnabled: Bool)
    func reloadTagsView()
    func dismissKeyboard()
    func setMinimumDateForTypeEndAtDate(minDate: Date)
    func updateDay(with date: Date, dateString: String)
    func updateStartAtDate(with date: Date, dateString: String)
    func updateEndAtDate(with date: Date, dateString: String)
    func updateProject(name: String, color: UIColor)
    func setActivityIndicator(isAnimating: Bool)
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState)
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
    func viewWillAppear()
    func viewDidDisappear()
    func viewShouldUpdateColors()
    func configure(_ cell: TagCollectionViewCellable, for indexPath: IndexPath)
    func projectButtonTapped()
    func viewRequestedForNumberOfTags() -> Int
    func viewRequestedForTag(at index: IndexPath) -> ProjectTag?
    func viewSelectedTag(at index: IndexPath)
    func isTagSelected(at index: IndexPath) -> Bool
    func taskNameDidChange(value: String?)
    func taskURLDidChange(value: String?)
    func taskURLIsHidden() -> Bool
    func viewChanged(startAtDate date: Date)
    func viewChanged(day: Date)
    func viewChanged(endAtDate date: Date)
    func viewRequestedToSave()
    func saveWithFillingCheckboxTapped(isActive: Bool)
    func viewHasBeenTapped()
}

class WorkTimeViewModel: KeyboardManagerObserverable {
    private weak var userInterface: WorkTimeViewModelOutput?
    private weak var coordinator: WorkTimeCoordinatorType?
    private let contentProvider: WorkTimeContentProviderType
    private let errorHandler: ErrorHandlerType
    private let calendar: CalendarType
    private let keyboardManager: KeyboardManagerable
    private let lastTask: TaskForm?
    private let flowType: FlowType
    
    private var projects: [SimpleProjectRecordDecoder]
    private var taskForm: TaskFormType {
        didSet {
            self.updateUI()
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
        keyboardManager: KeyboardManagerable,
        flowType: FlowType,
        taskFormFactory: TaskFormFactoryType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.calendar = calendar
        self.keyboardManager = keyboardManager
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
            case .editEntry: return R.string.localizable.worktimeform_edit_entry_title()
            case .newEntry, .duplicateEntry: return R.string.localizable.worktimeform_new_entry_title()
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
    
    func viewWillAppear() {
        self.keyboardManager.setKeyboardStateChangeHandler(for: self) { [weak userInterface] state in
            userInterface?.keyboardStateDidChange(to: state)
        }
    }
    
    func viewDidDisappear() {
        self.keyboardManager.removeHandler(for: self)
    }
    
    func viewShouldUpdateColors() {
        self.userInterface?.updateColors()
        self.userInterface?.reloadTagsView()
        self.updateUI()
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
        self.tags.count
    }
    
    func viewRequestedForTag(at index: IndexPath) -> ProjectTag? {
        self.tags[safeIndex: index.row]
    }
    
    func isTagSelected(at index: IndexPath) -> Bool {
        self.tags[safeIndex: index.row] == self.taskForm.tag
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
    
    func taskURLIsHidden() -> Bool {
        self.taskForm.isTaskURLHidden
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
        self.saveTask()
    }
    
    func saveWithFillingCheckboxTapped(isActive: Bool) {
        let newValue = !isActive
        self.taskForm.saveWithFilling = newValue
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
    private func setUpUI() {
        self.userInterface?.setUp()
        switch self.flowType {
        case .editEntry:
            self.userInterface?.setSaveWithFilling(isHidden: true)
        case .newEntry, .duplicateEntry:
            self.userInterface?.setSaveWithFilling(isHidden: false)
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
        
        self.userInterface?.setBodyView(isHidden: self.taskForm.isLunch)
        self.userInterface?.setTaskURLView(isHidden: self.taskForm.isTaskURLHidden)
        self.userInterface?.setBody(text: self.taskForm.body)
        self.userInterface?.setTask(urlString: self.taskForm.urlString)
        self.userInterface?.setTagsCollectionView(isHidden: !self.taskForm.isProjectTaggable)
        self.updateEndAtDateView(with: endDate)
        self.updateStartAtDateView(with: startDate)
        self.userInterface?.updateProject(
            name: self.taskForm.project?.name ?? R.string.localizable.worktimeform_select_project(),
            color: self.taskForm.project?.color ?? .clear)
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
    
    private func saveTask() {
        let completion: WorkTimeSaveTaskCompletion = self.getSaveCompletion()
        self.userInterface?.setSaveButton(isEnabled: false)
        self.userInterface?.setActivityIndicator(isAnimating: true)
        self.taskForm.saveWithFilling
            ? self.contentProvider.saveWithFilling(taskForm: self.taskForm, completion: completion)
            : self.contentProvider.save(taskForm: self.taskForm, completion: completion)
    }
    
    private func getSaveCompletion() -> WorkTimeSaveTaskCompletion {
        return { [weak self] result in
            self?.userInterface?.setActivityIndicator(isAnimating: false)
            switch result {
            case .success:
                self?.coordinator?.dismissView(isTaskChanged: true)
            case let .failure(error):
                self?.userInterface?.setSaveButton(isEnabled: true)
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    private func updateUI() {
        let errors = self.contentProvider.getValidationErrors(forTaskForm: self.taskForm)
        self.userInterface?.setSaveButton(isEnabled: errors.isEmpty)
        self.userInterface?.setSaveWithFilling(isChecked: self.taskForm.saveWithFilling)
        self.updateUI(with: errors)
    }
    
    private func updateUI(with errors: [UIError]) {
        self.userInterface?.setProject(isHighlighted: errors.contains(.cannotBeEmpty(.projectTextField)))
        self.userInterface?.setDay(isHighlighted: errors.contains(.cannotBeEmpty(.dayTextField)))
        self.userInterface?.setStartsAt(isHighlighted: errors.contains(.cannotBeEmpty(.startsAtTextField))
            || errors.contains(.workTimeGreaterThan))
        self.userInterface?.setEndsAt(isHighlighted: errors.contains(.cannotBeEmpty(.endsAtTextField))
            || errors.contains(.workTimeGreaterThan))
        self.userInterface?.setBody(isHighlighted: errors.contains(.cannotBeEmpty(.taskNameTextField)))
        self.userInterface?.setTaskURL(isHighlighted: errors.contains(.cannotBeEmpty(.taskUrlTextField))
            || errors.contains(.invalidFormat(.taskUrlTextField)))
    }
}
