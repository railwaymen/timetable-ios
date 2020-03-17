//
//  TaskHistoryViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

protocol TaskHistoryViewModelOutput: class {
    func setUp()
    func reloadData()
    func setActivityIndicator(isHidden: Bool)
}

protocol TaskHistoryViewModelType: class {
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func configure(_ cell: WorkTimeTableViewCellable, for indexPath: IndexPath)
    func closeButtonTapped()
}

class TaskHistoryViewModel {
    private weak var userInterface: TaskHistoryViewModelOutput?
    private weak var coordinator: TaskHistoryCoordinatorType?
    private let apiClient: ApiClientWorkTimesType
    private let errorHandler: ErrorHandlerType
    private let taskForm: TaskFormType
    
    private var workTime: WorkTimeDecoder?
    private var fetchTask: RestlerTaskType?
    
    // MARK: - Initialization
    init(
        userInterface: TaskHistoryViewModelOutput,
        coordinator: TaskHistoryCoordinatorType,
        apiClient: ApiClientWorkTimesType,
        errorHandler: ErrorHandlerType,
        taskForm: TaskFormType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.taskForm = taskForm
    }
    
    deinit {
        self.fetchTask?.cancel()
    }
}

// MARK: - TaskHistoryViewModelType
extension TaskHistoryViewModel: TaskHistoryViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUp()
        self.fetchTaskHistory()
    }
    
    func numberOfSections() -> Int {
        return self.workTime?.versions.count ?? 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func configure(_ cell: WorkTimeTableViewCellable, for indexPath: IndexPath) {
        guard let workTime = self.workTime(for: indexPath) else { return }
        let viewModel = WorkTimeTableViewCellModel(
            userInterface: cell,
            parent: self,
            workTime: workTime)
        cell.configure(viewModel: viewModel)
    }
    
    func closeButtonTapped() {
        self.coordinator?.dismiss()
    }
}

// MARK: - WorkTimeTableViewCellModelParentType
extension TaskHistoryViewModel: WorkTimeTableViewCellModelParentType {
    func openTask(for workTime: WorkTimeDisplayed) {
        guard let task = workTime.task, let url = URL(string: task) else { return }
        self.coordinator?.openWithSafari(url: url)
    }
}

// MARK: - Private
extension TaskHistoryViewModel {
    private func fetchTaskHistory() {
        guard let identifier = self.taskForm.workTimeIdentifier else { return assertionFailure("There's no workTimeIdentifier to fetch data.") }
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.fetchTask = self.apiClient.fetchWorkTimeDetails(identifier: identifier) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            guard let self = self else { return }
            switch result {
            case let .success(decoder):
                self.workTime = decoder
                self.userInterface?.reloadData()
            case let .failure(error):
                self.errorHandler.throwing(error: error)
            }
        }
    }
    
    private func workTime(for indexPath: IndexPath) -> WorkTimeDisplayed? {
        guard indexPath.row == 0,
            let workTime = self.workTime else { return nil }
        let itemFromEnd = workTime.versions.count - indexPath.section - 1
        guard let version = workTime.versions[safeIndex: itemFromEnd] else { return nil }
        return WorkTimeDisplayed(workTime: workTime, version: version)
    }
}
