//
//  ErrorViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ErrorViewModelParentType: class {
    func update(error: Error)
}

protocol ErrorViewModelOutput: class {
    func setUp(refreshIsHidden: Bool)
    func update(title: String)
}

protocol ErrorViewModelType: class {
    func viewDidConfigure()
    func refreshButtonTapped()
}

class ErrorViewModel {
    private weak var userInterface: ErrorViewModelOutput?
    private var error: Error
    private let actionHandler: (() -> Void)?
    
    // MARK: - Initialization
    init(
        userInterface: ErrorViewModelOutput?,
        error: Error,
        actionHandler: (() -> Void)?
    ) {
        self.userInterface = userInterface
        self.error = error
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
    func update(error: Error) {
        self.error = error
        self.updateErrorTitle()
    }
}

// MARK: - Private
extension ErrorViewModel {
    private func updateErrorTitle() {
        var title: String = ""
        if let error = self.error as? UIError {
            title = error.localizedDescription
        } else if let error = self.error as? ApiClientError {
            title = error.type.localizedDescription
        }
        self.userInterface?.update(title: title)
    }
}
