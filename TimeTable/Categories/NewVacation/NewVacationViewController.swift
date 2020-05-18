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
    @IBOutlet private var optionalStaticLabel: UILabel!
    @IBOutlet private var noteTextView: AttributedTextView!
    @IBOutlet private var saveButton: AttributedButton!
    
    @IBOutlet private var textFieldsHeightConstraints: [NSLayoutConstraint]!
    @IBOutlet private var saveButtonHeightConstraint: NSLayoutConstraint!
    
    private var startDatePicker: UIDatePicker!
    private var endDatePicker: UIDatePicker!
    private var typePicker: UIPickerView!
    
    private var viewModel: NewVacationViewModelType!

    // MARK: - Overridden
    override func loadView() {
        super.loadView()
        self.viewModel.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.viewDidDisappear()
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        self.viewModel.closeButtonTapped()
    }

    @objc private func startDateTextFieldChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(startAtDate: sender.date)
    }
    
    @objc private func endDateTextFieldChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(endAtDate: sender.date)
    }
    
    @IBAction private func saveButtonTapped() {
        self.viewModel.saveButtonTapped()
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel.viewTapped()
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
        self.viewModel.viewSelectedType(at: row)
    }
}

// MARK: - UITextViewDelegate
extension NewVacationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.noteTextViewDidChange(text: textView.text)
    }
}

// MARK: - NewVacationViewModelOutput
extension NewVacationViewController: NewVacationViewModelOutput {
    func setUp(availableVacationDays: String) {
        self.title = R.string.localizable.newvacation_title()
        self.daysLabel.text = availableVacationDays
        self.setUpBarButtons()
        self.setUpStartDayPickerView()
        self.setUpEndDayPickerView()
        self.setUpTypePickerView()
        self.setUpNoteTextView()
        self.setUpSaveButton()
        self.setUpConstraints()
        self.setUpActivityIndicator()
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.activityIndicator.set(isAnimating: !isHidden)
    }
    
    func setNote(text: String) {
        self.noteTextView.text = text
    }
    
    func setMinimumDateForStartDate(minDate: Date) {
        self.startDatePicker.minimumDate = minDate
    }
    
    func setMinimumDateForEndDate(minDate: Date) {
        self.endDatePicker.minimumDate = minDate
    }
    
    func updateStartDate(with date: Date, dateString: String) {
        self.startDayTextField.text = dateString
        self.startDatePicker?.date = date
    }
    
    func updateEndDate(with date: Date, dateString: String) {
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
        guard self.isViewLoaded else { return }
        let bottomInset = max(0, height - self.scrollView.safeAreaInsets.bottom)
        self.scrollView.contentInset.bottom = bottomInset
        self.scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
    
    func setNote(isHighlighted: Bool) {
        self.set(self.noteTextView, isHighlighted: isHighlighted)
    }
    
    func setOptionalLabel(isHidden: Bool) {
        self.optionalStaticLabel.set(isHidden: isHidden)
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
        self.setUpTimePicker(&self.startDatePicker, selector: #selector(self.startDateTextFieldChanged))
        self.startDayTextField.inputView = self.startDatePicker
        self.startDayTextField.setTextFieldAppearance()
    }
    
    private func setUpEndDayPickerView() {
        self.setUpTimePicker(&self.endDatePicker, selector: #selector(self.endDateTextFieldChanged))
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
    
    private func setUpSaveButton() {
        self.saveButton.setBackgroundColor(.enabledButton, forState: .normal)
        self.saveButton.setBackgroundColor(.disabledButton, forState: .disabled)
    }
    
    private func setUpConstraints() {
        self.textFieldsHeightConstraints.forEach {
            $0.constant = Constants.defaultTextFieldHeight
        }
        self.saveButtonHeightConstraint.constant = Constants.defaultButtonHeight
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
    
    private func set(_ view: UIView, isHighlighted: Bool) {
        view.set(
            borderColor: .textFieldBorderColor(isHighlighted: isHighlighted),
            animatingWithDuration: 0.3)
    }
}
