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
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var startDayTextField: UITextField!
    @IBOutlet private var endDayTextField: UITextField!
    @IBOutlet private var noteTextView: AttributedTextView!
    @IBOutlet private var saveButton: AttributedButton!
    
    @IBOutlet private var textFieldsHeightConstraints: [NSLayoutConstraint]!
    @IBOutlet private var saveButtonHeightConstraint: NSLayoutConstraint!
    
    private var startDatePicker: UIDatePicker!
    private var endDatePicker: UIDatePicker!
    
    private var viewModel: RegisterRemoteWorkViewModelType!
    
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

// MARK: - UITextViewDelegate
extension RegisterRemoteWorkViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.noteTextViewDidChange(text: textView.text)
    }
}

// MARK: - RegisterRemoteWorkViewModelOutput
extension RegisterRemoteWorkViewController: RegisterRemoteWorkViewModelOutput {
    func setUp() {
        self.setUpTitle()
        self.setUpBarButtons()
        self.setUpStartDayPickerView()
        self.setUpEndDayPickerView()
        self.setUpNoteTextView()
        self.setUpSaveButton()
        self.setUpActivityIndicator()
        self.setUpConstraints()
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
    
    func updateEndDate(with date: Date, dateString: String) {
        self.endDayTextField.text = dateString
        self.endDatePicker?.date = date
    }
    
    func keyboardHeightDidChange(to keyboardHeight: CGFloat) {
        guard self.isViewLoaded else { return }
        self.setBottomContentInset(keyboardHeight: keyboardHeight)
        self.setContentOffset()
    }
    
    private func setBottomContentInset(keyboardHeight: CGFloat) {
        let bottomInset = max(0, keyboardHeight - self.view.safeAreaInsets.bottom)
        self.scrollView.contentInset.bottom = bottomInset
        self.scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
    
    private func setContentOffset() {
        self.scrollView.scrollTo(.bottom, of: self.saveButton, addingOffset: 16, adjustingMode: .minimumMovement)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setSaveButton(isEnabled: Bool) {
        self.saveButton.setWithAnimation(isEnabled: isEnabled)
    }
    
    func setStartsAt(isHighlighted: Bool) {
        self.set(self.startDayTextField, isHighlighted: isHighlighted)
    }
    
    func setEndsAt(isHighlighted: Bool) {
        self.set(self.endDayTextField, isHighlighted: isHighlighted)
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
    private func setUpTitle() {
        self.title = R.string.localizable.registerremotework_title()
    }
    
    private func setUpBarButtons() {
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .closeButton,
            target: self,
            action: #selector(self.closeButtonTapped))
        self.navigationItem.setRightBarButton(closeButton, animated: false)
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
    
    private func setUpNoteTextView() {
        self.noteTextView.setTextFieldAppearance()
    }
    
    private func setUpSaveButton() {
        self.saveButton.setBackgroundColor(.enabledButton, forState: .normal)
        self.saveButton.setBackgroundColor(.disabledButton, forState: .disabled)
    }
    
    private func setUpActivityIndicator() {
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.setActivityIndicator(isHidden: true)
    }
    
    private func setUpConstraints() {
        self.textFieldsHeightConstraints.forEach {
            $0.constant = Constants.defaultTextFieldHeight
        }
        self.saveButtonHeightConstraint.constant = Constants.defaultButtonHeight
    }
    
    private func setUpTimePicker(_ picker: inout UIDatePicker?, selector: Selector) {
        picker = UIDatePicker()
        picker?.datePickerMode = .dateAndTime
        picker?.minuteInterval = 15
        picker?.addTarget(self, action: selector, for: .valueChanged)
    }
    
    private func set(_ view: UIView, isHighlighted: Bool) {
        view.set(
            borderColor: .textFieldBorderColor(isHighlighted: isHighlighted),
            animatingWithDuration: 0.3)
    }
}
