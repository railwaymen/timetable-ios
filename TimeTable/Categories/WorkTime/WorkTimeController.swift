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
    @IBOutlet private var fromDateTextField: UITextField!
    @IBOutlet private var toDateTextField: UITextField!
    @IBOutlet private var projectTextField: UITextField!
    @IBOutlet private var timeLabel: UILabel!
    
    private var projectPicker: UIPickerView!
    private var fromDatePicker: UIDatePicker!
    private var toDatePicker: UIDatePicker!
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
        viewModel.viewRequesetdToSave()
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        viewModel?.viewHasBeenTapped()
    }
    
    @IBAction func fromDateTextFieldDidBegin(_ sender: UITextField) {
        viewModel.setDefaultFromDate()
    }

    @objc private func fromDateTextFieldDidChanged(_ sender: UIDatePicker) {
        viewModel.viewChanged(fromDate: sender.date)
    }
    
    @IBAction func toDateTextFieldDidBegin(_ sender: UITextField) {
        viewModel.setDefaultToDate()
    }    
    
    @objc private func toDateTextFieldDidChanged(_ sender: UIDatePicker) {
        viewModel.viewChanged(toDate: sender.date)
    }
}

extension WorkTimeController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.viewRequestedForProjectTitle(atRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.viewSelectedProject(atRow: row)
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
        
        fromDatePicker = UIDatePicker()
        fromDatePicker.datePickerMode = .dateAndTime
        fromDatePicker.addTarget(self, action: #selector(fromDateTextFieldDidChanged), for: .valueChanged)
        fromDateTextField.inputView = fromDatePicker

        toDatePicker = UIDatePicker()
        toDatePicker.datePickerMode = .dateAndTime
        toDatePicker.addTarget(self, action: #selector(toDateTextFieldDidChanged), for: .valueChanged)
        toDateTextField.inputView = toDatePicker
    }
    
    func dismissView() {
        self.dismiss(animated: true)
    }
    
    func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    func setMinimumDateForTypeToDate(minDate: Date) {
        toDatePicker.minimumDate = minDate
    }
    
    func updateFromDate(withDate date: Date, dateString: String) {
        fromDateTextField.text = dateString
        fromDatePicker.date = date
    }
    
    func updateToDate(withDate date: Date, dateString: String) {
        toDateTextField.text = dateString
        toDatePicker.date = date
    }
    
    func updateTimeLable(withTitle title: String?) {
        timeLabel.text = title
    }
}

// MARK: - WorkTimeViewControllerType
extension WorkTimeController: WorkTimeViewControllerType {
    func configure(viewModel: WorkTimeViewModelType) {
        self.viewModel = viewModel
    }
}
