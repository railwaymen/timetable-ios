//
//  WorkTimeController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 09/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimeViewControlleralbe = (UIViewController & WorkTimeViewControllerType & WorkTimeViewModelOutput)

protocol WorkTimeViewControllerType: class {
    func configure(viewModel: WorkTimeViewModelType)
}

class WorkTimeController: UIViewController {
    
    @IBOutlet private var projectButton: UIButton!
    @IBOutlet private var timeLabel: UILabel!
    
    private var viewModel: WorkTimeViewModelType!
    
    // MARK: - Life Cycle
    
    // MARK: - Action
    @IBAction private func projectButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction private func taskTextFieldDidChange(_ sender: UITextField) {
    
    }
    
    @IBAction private func taskURLTextFieldDidChange(_ sender: UITextField) {
        
    }
    
    @IBAction private func fromDateButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction private func toDateButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        
    }
}

// MARK: - WorkTimeViewModelOutput
extension WorkTimeController: WorkTimeViewModelOutput {
    
}

// MARK: - WorkTimeViewControllerType
extension WorkTimeController: WorkTimeViewControllerType {
    func configure(viewModel: WorkTimeViewModelType) {
        self.viewModel = viewModel
    }
}
