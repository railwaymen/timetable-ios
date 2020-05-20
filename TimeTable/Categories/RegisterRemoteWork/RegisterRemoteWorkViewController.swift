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
    
    private let bottomPadding: CGFloat = 16
    private var viewModel: RegisterRemoteWorkViewModelType!
    private var startDatePicker: UIDatePicker!
    private var endDatePicker: UIDatePicker!
    private var lastKeyboardHeight: CGFloat?
    private var focusedView: UIView? {
        didSet {
            self.setContentOffset(animated: true)
        }
    }
    
    private var viewsOrder: [UIView] {
        [self.startDayTextField, self.endDayTextField, self.noteTextView, self.saveButton]
    }
    
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        self.viewModel.viewShouldUpdateColors()
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        self.viewModel.closeButtonTapped()
    }
    
    @IBAction private func textFieldDidBeginEditing(_ sender: UITextField) {
        self.focusedView = sender
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
        self.setContentOffset(animated: false)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.focusedView = textView
        return true
    }
}

// MARK: - RegisterRemoteWorkViewModelOutput
extension RegisterRemoteWorkViewController: RegisterRemoteWorkViewModelOutput {
    func setUp() {
        self.setUpBarButtons()
        self.setUpStartDayPickerView()
        self.setUpEndDayPickerView()
        self.setUpNoteTextView()
        self.setUpSaveButtonColors()
        self.setUpActivityIndicator()
        self.setUpConstraints()
    }
    
    func setUp(title: String) {
        self.title = title
    }
    
    func updateColors() {
        self.startDayTextField.setTextFieldAppearance()
        self.endDayTextField.setTextFieldAppearance()
        self.noteTextView.setTextFieldAppearance()
        self.setUpSaveButtonColors()
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
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        guard self.isViewLoaded else { return }
        if keyboardState == .hidden {
            self.focusedView = nil
        }
        self.setBottomContentInset(keyboardHeight: keyboardState.keyboardHeight)
        self.setContentOffset(animated: true)
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
    
    private func setUpSaveButtonColors() {
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
    
    private func setBottomContentInset(keyboardHeight: CGFloat) {
        let bottomInset = max(0, keyboardHeight - self.view.safeAreaInsets.bottom)
        self.scrollView.contentInset.bottom = bottomInset
        self.scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
    
    private func setContentOffset(animated: Bool) {
        guard let currentView = self.focusedView else { return }
        guard let nextView = self.getViewUnderFocusedView() else { return }
        DispatchQueue.main.async {
            self.scrollView.layoutIfNeeded()
            if let textView = currentView as? UITextView,
                let selectedRange = textView.selectedTextRange {
                let cursorYPosition = min(textView.firstRect(for: selectedRange).minY, textView.bounds.maxY)
                let action = self.scrollView.buildScrollAction()
                    .scroll(to: .top, of: currentView, addingOffset: -32)
                    .scroll(to: .bottom, of: nextView, addingOffset: self.bottomPadding)
                    .scroll(to: .top, of: currentView, addingOffset: cursorYPosition - self.bottomPadding)
                action.perform(animated: animated)
            } else {
                self.scrollView.buildScrollAction()
                    .scroll(to: .bottom, of: nextView, addingOffset: self.bottomPadding)
                    .scroll(to: .top, of: currentView, addingOffset: -32)
                    .perform(animated: animated)
            }
        }
    }
    
    private func getViewUnderFocusedView() -> UIView? {
        guard let focusedView = self.focusedView else { return nil }
        guard let focusedViewIndex = self.viewsOrder.firstIndex(of: focusedView) else { return nil }
        return viewsOrder[safeIndex: focusedViewIndex + 1]
    }
}
