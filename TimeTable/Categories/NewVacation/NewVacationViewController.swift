//
//  NewVacationViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias NewVacationViewControllerable = (UIViewController & NewVacationViewControllerType & NewVacationViewModelOutput)

protocol NewVacationViewControllerType: class {
    func configure(viewModel: NewVacationViewModelType)
}

class NewVacationViewController: UIViewController {
    private var viewModel: NewVacationViewModelType!
    
    // MARK: - Overridden
    override func loadView() {
        super.loadView()
        self.viewModel.loadView()
    }
    
    // MARK: - Actions
    @objc func closeButtonTapped() {
        self.viewModel.closeButtonTapped()
    }
}

// MARK: - NewVacationViewModelOutput
extension NewVacationViewController: NewVacationViewModelOutput {
    func setUp() {
        self.title = R.string.localizable.newvacation_title()
        self.setUpBarButtons()
    }
}

// MARK: - NewVacationViewControllerType
extension NewVacationViewController: NewVacationViewControllerType {
    func configure(viewModel: NewVacationViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension NewVacationViewController {
    private func setUpBarButtons() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.closeButtonTapped))
        self.navigationItem.setRightBarButtonItems([closeButton], animated: false)
    }
}
