//
//  ProjectPickerViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol ProjectPickerViewModelOutput: class {
    func setUp()
    func reloadData()
    func setBottomContentInset(_ inset: CGFloat)
}

protocol ProjectPickerViewModelType: class {
    func loadView()
    func viewWillAppear()
    func viewDidDisappear()
    func numberOfRows(in section: Int) -> Int
    func configure(cell: ProjectPickerCellable, for indexPath: IndexPath)
    func updateSearchResults(for text: String)
    func cellDidSelect(at indexPath: IndexPath)
    func closeButtonTapped()
}

class ProjectPickerViewModel: KeyboardManagerObserverable {
    private weak var userInterface: ProjectPickerViewModelOutput?
    private weak var coordinator: ProjectPickerCoordinatorType?
    private let keyboardManager: KeyboardManagerable
    
    private let projects: [SimpleProjectRecordDecoder]
    private var filteredProjects: [SimpleProjectRecordDecoder] = []
    
    // MARK: - Initialization
    init(
        userInterface: ProjectPickerViewModelOutput?,
        coordinator: ProjectPickerCoordinatorType?,
        keyboardManager: KeyboardManagerable,
        projects: [SimpleProjectRecordDecoder]
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.keyboardManager = keyboardManager
        self.projects = projects
        self.filteredProjects = projects
    }
}

// MARK: - ProjectPickerViewModelType
extension ProjectPickerViewModel: ProjectPickerViewModelType {
    func loadView() {
        self.userInterface?.setUp()
    }
    
    func viewWillAppear() {
        self.keyboardManager.setKeyboardHeightChangeHandler(for: self) { [weak userInterface] keyboardHeight in
            userInterface?.setBottomContentInset(keyboardHeight)
        }
    }
    
    func viewDidDisappear() {
        self.keyboardManager.removeHandler(for: self)
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard section == 0 else { return 0 }
        return self.filteredProjects.count
    }
    
    func configure(cell: ProjectPickerCellable, for indexPath: IndexPath) {
        guard let project = self.project(at: indexPath) else { return }
        let viewModel = ProjectPickerCellModel(
            userInterface: cell,
            project: project)
        cell.configure(viewModel: viewModel)
    }
    
    func updateSearchResults(for text: String) {
        self.filterProjects(with: text)
        self.userInterface?.reloadData()
    }
    
    func cellDidSelect(at indexPath: IndexPath) {
        self.finish(with: self.project(at: indexPath))
    }
    
    func closeButtonTapped() {
        self.finish(with: nil)
    }
}

// MARK: - Private
extension ProjectPickerViewModel {
    private func filterProjects(with text: String) {
        self.filteredProjects = text.isEmpty
            ? self.projects
            : self.projects.filter {
                $0.name.lowercased().contains(text.lowercased())
            }
    }
    
    private func project(at indexPath: IndexPath) -> SimpleProjectRecordDecoder? {
        guard indexPath.section == 0 else { return nil }
        return self.filteredProjects[safeIndex: indexPath.row]
    }
    
    private func finish(with project: SimpleProjectRecordDecoder?) {
        self.coordinator?.finishFlow(project: project)
    }
}
