//
//  VacationsViewContorller.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias VacationsViewContorllerable = (UIViewController & VacationsViewContorllerType & VacationsViewModelOutput)

protocol VacationsViewContorllerType: class {
    func configure(viewModel: VacationsViewModelType)
}

class VacationsViewContorller: UIViewController {
    private var viewModel: VacationsViewModelType!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - VacationsViewModelOutput
extension VacationsViewContorller: VacationsViewModelOutput {
    
}

// MARK: - VacationsViewContorllerType
extension VacationsViewContorller: VacationsViewContorllerType {
    func configure(viewModel: VacationsViewModelType) {
        self.viewModel = viewModel
    }
}
