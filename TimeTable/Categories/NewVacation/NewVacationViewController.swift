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
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var daysLabel: UILabel!
    @IBOutlet private var startDayTextField: UITextField!
    @IBOutlet private var endDayTextField: UITextField!
    @IBOutlet private var typeTextField: UITextField!
    @IBOutlet private var noteTextView: UITextView!
    @IBOutlet private var saveButton: AttributedButton!
    
    private var startDatePicker: UIDatePicker!
    private var endDatePicker: UIDatePicker!
    private var typePicker: UIPickerView!
    
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

    @objc private func startDateTextFieldDidChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(startAtDate: sender.date)
    }
    
    @objc private func endDateTextFieldDidChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(endAtDate: sender.date)
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel.viewHasBeenTapped()
    }
}

// MARK: - UIPickerViewDataSource
extension NewVacationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.numberOfTypes()
    }
}

// MARK: - UIPickerViewDelegate
extension NewVacationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.titleOfType(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.viewSelectType(at: row)
    }
}

// MARK: - NewVacationViewModelOutput
extension NewVacationViewController: NewVacationViewModelOutput {
    func setUp() {
        self.title = R.string.localizable.newvacation_title()
        self.setUpBarButtons()
        self.setUpStartDayPickerView()
        self.setUpEndDayPickerView()
        self.setUpTypePickerView()
        self.setUpNoteTextView()
        self.setUpSaveButtons()
        self.setUpActivityIndicator()
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.activityIndicator.set(isAnimating: !isHidden)
    }
    
    func setNote(text: String) {
        self.noteTextView.text = text
    }
    
    func setMinimumDateForEndDate(minDate: Date) {
        self.endDatePicker.minimumDate = minDate
    }
    
    func updateStartDate(with date: Date, dateString: String) {
        self.startDayTextField.text = dateString
        self.startDatePicker?.date = date
    }
    
    func updateEndAtDate(with date: Date, dateString: String) {
        self.endDayTextField.text = dateString
        self.endDatePicker?.date = date
    }
    
    func updateType(name: String) {
        self.typeTextField.text = name
    }
    
    func setSaveButton(isEnabled: Bool) {
        self.saveButton.setWithAnimation(isEnabled: isEnabled)
    }
    
    func setBottomContentInset(_ height: CGFloat) {
        guard self.viewIfLoaded != nil else { return }
        let bottomInset = max(0, height - self.scrollView.safeAreaInsets.bottom)
        self.scrollView.contentInset.bottom = bottomInset
        self.scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
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
    
    private func setUpStartDayPickerView() {
        self.setUpTimePicker(&self.startDatePicker, selector: #selector(self.startDateTextFieldDidChanged))
        self.startDayTextField.inputView = self.startDatePicker
        self.startDayTextField.setTextFieldAppearance()
    }
    
    private func setUpEndDayPickerView() {
        self.setUpTimePicker(&self.endDatePicker, selector: #selector(self.endDateTextFieldDidChanged))
        self.endDayTextField.inputView = self.endDatePicker
        self.endDayTextField.setTextFieldAppearance()
    }
    
    private func setUpTypePickerView() {
        self.typePicker = UIPickerView()
        self.typeTextField.inputView = self.typePicker
        self.typePicker.dataSource = self
        self.typePicker.delegate = self
        self.typeTextField.setTextFieldAppearance()
    }
    
    private func setUpNoteTextView() {
        self.noteTextView.setTextFieldAppearance()
    }
    
    private func setUpSaveButtons() {
        self.saveButton.setBackgroundColor(.enabledButton, forState: .normal)
        self.saveButton.setBackgroundColor(.disabledButton, forState: .disabled)
    }
    
    private func setUpActivityIndicator() {
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.setActivityIndicator(isHidden: true)
    }
    
    private func setUpTimePicker(_ picker: inout UIDatePicker?, selector: Selector) {
        picker = UIDatePicker()
        picker?.datePickerMode = .date
        picker?.addTarget(self, action: selector, for: .valueChanged)
    }
}
