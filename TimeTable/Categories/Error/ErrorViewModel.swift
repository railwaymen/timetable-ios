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
    init(userInterface: ErrorViewModelOutput?,
         error: Error,
         actionHandler: (() -> Void)?) {
        self.userInterface = userInterface
        self.error = error
        self.actionHandler = actionHandler
    }
}

// MARK: - ErrorViewModelType
extension ErrorViewModel: ErrorViewModelType {
    func viewDidConfigure() {
        userInterface?.setUp(refreshIsHidden: actionHandler == nil)
        updateErrorTitle()
    }
    
    func refreshButtonTapped() {
        actionHandler?()
    }
}

// MARK: - ErrorViewModelParentType
extension ErrorViewModel: ErrorViewModelParentType {
    func update(error: Error) {
        self.error = error
        updateErrorTitle()
    }
}

// MARK: - Private
private extension ErrorViewModel {
    private func updateErrorTitle() {
        var title: String = ""
        if let error = error as? UIError {
            title = error.localizedDescription
        } else if let error = error as? ApiClientError {
            title = error.type.localizedDescription
        }
        userInterface?.update(title: title)
    }
}
