//
//  RegisterRemoteWorkViewController.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias RegisterRemoteWorkViewControllerable =
    UIViewController
    & RegisterRemoteWorkViewControllerType
    & RegisterRemoteWorkViewModelOutput

protocol RegisterRemoteWorkViewControllerType: class {
    func configure(viewModel: RegisterRemoteWorkViewModelType)
}

class RegisterRemoteWorkViewController: UIViewController {
    private var viewModel: RegisterRemoteWorkViewModelType!
    
    // MARK: - Overridden
    override func loadView() {
        super.loadView()
        self.viewModel.loadView()
    }
}

// MARK: - RegisterRemoteWorkViewModelOutput
extension RegisterRemoteWorkViewController: RegisterRemoteWorkViewModelOutput {
    func setUp() {
        
    }
}

// MARK: - RegisterRemoteWorkViewControllerType
extension RegisterRemoteWorkViewController: RegisterRemoteWorkViewControllerType {
    func configure(viewModel: RegisterRemoteWorkViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension RegisterRemoteWorkViewController {
    
}
