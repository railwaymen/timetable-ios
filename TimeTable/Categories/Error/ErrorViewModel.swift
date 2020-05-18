//
//  ErrorViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ErrorViewModelParentType: class {
    func update(localizedError: LocalizedError)
    func setRefreshButton(isEnabled: Bool)
}

protocol ErrorViewModelOutput: class {
    func setUp(refreshIsHidden: Bool)
    func update(title: String)
    func setRefreshButton(isEnabled: Bool)
}

protocol ErrorViewModelType: class {
    func viewDidConfigure()
    func refreshButtonTapped()
}

class ErrorViewModel {
    private weak var userInterface: ErrorViewModelOutput?
    private var localizedError: LocalizedError
    private let actionHandler: (() -> Void)?
    
    // MARK: - Initialization
    init(
        userInterface: ErrorViewModelOutput?,
        localizedError: LocalizedError,
        actionHandler: (() -> Void)?
    ) {
        self.userInterface = userInterface
        self.localizedError = localizedError
        self.actionHandler = actionHandler
    }
}

// MARK: - ErrorViewModelType
extension ErrorViewModel: ErrorViewModelType {
    func viewDidConfigure() {
        self.userInterface?.setUp(refreshIsHidden: self.actionHandler == nil)
        self.updateErrorTitle()
    }
    
    func refreshButtonTapped() {
        self.actionHandler?()
    }
}

// MARK: - ErrorViewModelParentType
extension ErrorViewModel: ErrorViewModelParentType {
    func update(localizedError: LocalizedError) {
        self.localizedError = localizedError
        self.updateErrorTitle()
    }
    
    func setRefreshButton(isEnabled: Bool) {
        self.userInterface?.setRefreshButton(isEnabled: isEnabled)
    }
}

// MARK: - Private
extension ErrorViewModel {
    private func updateErrorTitle() {
        self.userInterface?.update(title: self.localizedError.localizedDescription)
    }
}
