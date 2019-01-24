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
    @IBOutlet private var dayTextField: UITextField!
    @IBOutlet private var startAtDateTextField: UITextField!
    @IBOutlet private var endAtDateTextField: UITextField!
    @IBOutlet private var projectTextField: UITextField!
    @IBOutlet private var taskURLViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var taskURLView: UIView!
    
    private var projectPicker: UIPickerView!
    private var dayPicker: UIDatePicker!
    private var startAtDatePicker: UIDatePicker!
    private var endAtDatePicker: UIDatePicker!
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
    
    @IBAction private func taskTextFieldDidChange(_ sender: UITextField) {
        viewModel.taskNameDidChange(value: sender.text)
    }
    
    @IBAction private func taskTextFieldDidBegin(_ sender: UITextField) {
        viewModel.setDefaultTask()
    }
    
    @IBAction private func taskURLTextFieldDidChange(_ sender: UITextField) {
        viewModel.taskURLDidChange(value: sender.text)
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        viewModel.viewRequestedToSave()
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        viewModel?.viewHasBeenTapped()
    }
    
    @IBAction private func dayTextFieldDidBegin(_ sender: UITextField) {
        viewModel.setDefaultDay()
    }
    
    @objc private func dayTextFieldDidChanged(_ sender: UIDatePicker) {
        viewModel.viewChanged(day: sender.date)
    }
    
    @IBAction private func startAtDateTextFieldDidBegin(_ sender: UITextField) {
        viewModel.setDefaultStartAtDate()
    }

    @objc private func startAtDateTextFieldDidChanged(_ sender: UIDatePicker) {
        viewModel.viewChanged(startAtDate: sender.date)
    }
    
    @IBAction private func endAtDateTextFieldDidBegin(_ sender: UITextField) {
        viewModel.setDefaultEndAtDate()
    }    
    
    @objc private func endAtDateTextFieldDidChanged(_ sender: UIDatePicker) {
        viewModel.viewChanged(endAtDate: sender.date)
    }
}

// MARK: - UIPickerViewDelegate 
extension WorkTimeController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.viewRequestedForProjectTitle(atRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.viewSelectedProject(atRow: row)
    }
}

// MARK: - UIPickerViewDataSource
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
    
    func setUp(currentProjectName: String, allowsTask: Bool) {
        taskURLViewHeightConstraint.constant = allowsTask ? 80 : 0
        taskURLView.isHidden = !allowsTask

        projectPicker = UIPickerView()
        projectPicker.delegate = self
        projectPicker.dataSource = self
        
        projectTextField.inputView = projectPicker
        projectTextField.text = currentProjectName
        
        dayPicker = UIDatePicker()
        dayPicker.datePickerMode = .date
        dayPicker.addTarget(self, action: #selector(dayTextFieldDidChanged), for: .valueChanged)
        dayTextField.inputView = dayPicker
        
        startAtDatePicker = UIDatePicker()
        startAtDatePicker.datePickerMode = .time
        startAtDatePicker.addTarget(self, action: #selector(startAtDateTextFieldDidChanged), for: .valueChanged)
        startAtDateTextField.inputView = startAtDatePicker

        endAtDatePicker = UIDatePicker()
        endAtDatePicker.datePickerMode = .time
        endAtDatePicker.addTarget(self, action: #selector(endAtDateTextFieldDidChanged), for: .valueChanged)
        endAtDateTextField.inputView = endAtDatePicker
    }
    
    func dismissView() {
        self.dismiss(animated: true)
    }
    
    func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    func setMinimumDateForTypeEndAtDate(minDate: Date) {
        endAtDatePicker.minimumDate = minDate
    }
    
    func updateDay(with date: Date, dateString: String) {
        dayTextField.text = dateString
        startAtDatePicker.date = date
    }
    
    func updateStartAtDate(with date: Date, dateString: String) {
        startAtDateTextField.text = dateString
        startAtDatePicker.date = date
    }
    
    func updateEndAtDate(with date: Date, dateString: String) {
        endAtDateTextField.text = dateString
        endAtDatePicker.date = date
    }
}

// MARK: - WorkTimeViewControllerType
extension WorkTimeController: WorkTimeViewControllerType {
    func configure(viewModel: WorkTimeViewModelType) {
        self.viewModel = viewModel
    }
}
