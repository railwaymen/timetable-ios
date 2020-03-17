//
//  TaskHistoryViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

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
    private let taskForm: TaskFormType
    
    // MARK: - Initialization
    init(
        userInterface: TaskHistoryViewModelOutput,
        coordinator: TaskHistoryCoordinatorType,
        taskForm: TaskFormType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.taskForm = taskForm
    }
}

// MARK: - TaskHistoryViewModelType
extension TaskHistoryViewModel: TaskHistoryViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUp()
        self.fetchTaskHistory()
    }
    
    func numberOfSections() -> Int {
        return 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 0
    }
    
    func configure(_ cell: WorkTimeTableViewCellable, for indexPath: IndexPath) {
        
    }
    
    func closeButtonTapped() {
        self.coordinator?.dismiss()
    }
}

// MARK: - Private
extension TaskHistoryViewModel {
    private func fetchTaskHistory() {
        
    }
}
