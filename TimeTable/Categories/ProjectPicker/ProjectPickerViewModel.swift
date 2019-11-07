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
    func viewDidLoad()
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
        
        setUpNotifications()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc private func changeKeyboardFrame(notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        userInterface?.setBottomContentInsets(keyboardHeight)
    }
    
    @objc private func keyboardWillHide() {
        userInterface?.setBottomContentInsets(0)
    }
    
    // MARK: - Private
    private func setUpNotifications() {
        notificationCenter.addObserver(self, selector: #selector(changeKeyboardFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(changeKeyboardFrame), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func filterProjects(with text: String) {
        filteredProjects = text.isEmpty ? projects : projects.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
    
    private func project(at indexPath: IndexPath) -> ProjectDecoder? {
        guard indexPath.section == 0 else { return nil }
        return filteredProjects[safeIndex: indexPath.row]
    }
    
    private func finish(with project: ProjectDecoder?) {
        coordinator?.finishFlow(project: project)
    }
}

// MARK: - ProjectPickerViewModelType
extension ProjectPickerViewModel: ProjectPickerViewModelType {
    func viewDidLoad() {
        userInterface?.setUp()
    }
    
    func numberOfRows(in section: Int) -> Int {
        return filteredProjects.count
    }
    
    func configure(cell: ProjectPickerCellable, for indexPath: IndexPath) {
        guard let project = project(at: indexPath) else { return }
        let viewModel = ProjectPickerCellModel(userInterface: cell,
                                               project: project)
        cell.configure(viewModel: viewModel)
    }
    
    func updateSearchResults(for text: String) {
        filterProjects(with: text)
        userInterface?.reloadData()
    }
    
    func cellDidSelect(at indexPath: IndexPath) {
        finish(with: project(at: indexPath))
    }
    
    func closeButtonTapped() {
        coordinator?.finishFlow(project: nil)
    }
}
