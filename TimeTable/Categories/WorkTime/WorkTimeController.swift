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
    
    @IBOutlet private var projectTextField: UITextField!
    @IBOutlet private var timeLabel: UILabel!
    
    private var projectPicker: UIPickerView!
    private var viewModel: WorkTimeViewModelType!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Action
    @IBAction private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.viewRequestedToFinish()
    }
    
    @IBAction private func projectButtonTapped(_ sender: UIButton) {
        viewModel.viewRequestedForProjectView()
    }
    
    @IBAction private func taskTextFieldDidChange(_ sender: UITextField) {
        viewModel.taskNameDidChange(value: sender.text)
    }
    
    @IBAction private func taskURLTextFieldDidChange(_ sender: UITextField) {
        viewModel.taskURLDidChange(value: sender.text)
    }
    
    @IBAction private func fromDateButtonTapped(_ sender: UIButton) {
        viewModel.viewRequestedForFromDateView()
    }
    
    @IBAction private func toDateButtonTapped(_ sender: UIButton) {
        viewModel.viewRequestedForToDateView()
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        viewModel.viewRequesetdToSave()
    }
}

extension WorkTimeController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.viewRequestedForProjectTitle(atRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension WorkTimeController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.viewRequestedForNumberOfProjects()
    }
}

// MARK: - WorkTimeViewModelOutput
extension WorkTimeController: WorkTimeViewModelOutput {
    func reloadProjectPicker() {
        projectPicker.reloadAllComponents()
    }
    
    func setUp(currentProjectName: String) {
        projectPicker = UIPickerView()
        projectPicker.delegate = self
        projectPicker.dataSource = self
        
        projectTextField.inputView = projectPicker
        projectTextField.text = currentProjectName
    }
    
    func dismissView() {
        self.dismiss(animated: true)
    }
}

// MARK: - WorkTimeViewControllerType
extension WorkTimeController: WorkTimeViewControllerType {
    func configure(viewModel: WorkTimeViewModelType) {
        self.viewModel = viewModel
    }
}
