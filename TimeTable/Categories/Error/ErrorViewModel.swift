//
//  ErrorViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ErrorViewModelOutput: class {
    func setUp(refreshIsHidden: Bool)
}

protocol ErrorViewModelType: class {
    func viewDidLoad()
    func refreshButtonTapped()
}

class ErrorViewModel {
    private weak var userInterface: ErrorViewModelOutput?
    private let error: Error
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
    func viewDidLoad() {
        userInterface?.setUp(refreshIsHidden: actionHandler == nil)
    }
    
    func refreshButtonTapped() {
        actionHandler?()
    }
}
