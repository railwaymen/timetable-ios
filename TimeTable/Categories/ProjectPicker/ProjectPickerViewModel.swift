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
    func setBottomContentInsets(_ inset: CGFloat)
}

protocol ProjectPickerViewModelType: class {
    func loadView()
    func numberOfRows(in section: Int) -> Int
    func configure(cell: ProjectPickerCellable, for indexPath: IndexPath)
    func updateSearchResults(for text: String)
    func cellDidSelect(at indexPath: IndexPath)
    func closeButtonTapped()
}

class ProjectPickerViewModel {
    private weak var userInterface: ProjectPickerViewModelOutput?
    private weak var coordinator: ProjectPickerCoordinatorType?
    private let notificationCenter: NotificationCenterType
    
    private let projects: [ProjectDecoder]
    private var filteredProjects: [ProjectDecoder] = []
    
    // MARK: - Initialization
    init(userInterface: ProjectPickerViewModelOutput?,
         coordinator: ProjectPickerCoordinatorType?,
         notificationCenter: NotificationCenterType,
         projects: [ProjectDecoder]) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.notificationCenter = notificationCenter
        self.projects = projects
        self.filteredProjects = projects
        
        self.setUpNotifications()
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc private func changeKeyboardFrame(notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        self.userInterface?.setBottomContentInsets(keyboardHeight)
    }
    
    @objc private func keyboardWillHide() {
        self.userInterface?.setBottomContentInsets(0)
    }
}

// MARK: - ProjectPickerViewModelType
extension ProjectPickerViewModel: ProjectPickerViewModelType {
    func loadView() {
        self.userInterface?.setUp()
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard section == 0 else { return 0 }
        return self.filteredProjects.count
    }
    
    func configure(cell: ProjectPickerCellable, for indexPath: IndexPath) {
        guard let project = self.project(at: indexPath) else { return }
        let viewModel = ProjectPickerCellModel(userInterface: cell,
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
    private func setUpNotifications() {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.changeKeyboardFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.changeKeyboardFrame),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func filterProjects(with text: String) {
        self.filteredProjects = text.isEmpty
            ? self.projects
            : self.projects.filter {
                $0.name.lowercased().contains(text.lowercased())
            }
    }
    
    private func project(at indexPath: IndexPath) -> ProjectDecoder? {
        guard indexPath.section == 0 else { return nil }
        return self.filteredProjects[safeIndex: indexPath.row]
    }
    
    private func finish(with project: ProjectDecoder?) {
        self.coordinator?.finishFlow(project: project)
    }
}
