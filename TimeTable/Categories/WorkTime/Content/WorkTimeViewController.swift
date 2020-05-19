//
//  WorkTimeViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 09/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimeViewControllerable = (UIViewController & WorkTimeViewControllerType & WorkTimeViewModelOutput)

protocol WorkTimeViewControllerType: class {
    func configure(viewModel: WorkTimeViewModelType)
}

class WorkTimeViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var projectView: AttributedView!
    @IBOutlet private var projectColorView: UIView!
    @IBOutlet private var projectTitleLabel: UILabel!
    @IBOutlet private var dayTextField: UITextField!
    @IBOutlet private var startAtDateTextField: UITextField!
    @IBOutlet private var endAtDateTextField: UITextField!
    @IBOutlet private var tagsCollectionView: UICollectionView!
    @IBOutlet private var bodyView: UIView!
    @IBOutlet private var bodyTextView: UITextView!
    @IBOutlet private var taskURLView: UIView!
    @IBOutlet private var taskURLTextField: UITextField!
    @IBOutlet private var saveWithFillingView: UIStackView!
    @IBOutlet private var saveWithFillingCheckbox: CheckBoxButton!
    @IBOutlet private var saveButton: AttributedButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private var textFieldsHeightConstraints: [NSLayoutConstraint]!
    @IBOutlet private var saveButtonHeightConstraint: NSLayoutConstraint!
    
    private let bottomPadding: CGFloat = 16
    private var dayPicker: UIDatePicker!
    private var startAtDatePicker: UIDatePicker!
    private var endAtDatePicker: UIDatePicker!
    private var viewModel: WorkTimeViewModelType!
    private var focusedView: UIView? {
        didSet {
            self.setContentOffset(animated: true)
        }
    }
    
    private var viewsOrder: [UIView] {
        [
            self.bodyTextView,
            self.taskURLTextField,
            self.saveButton
        ]
    }
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
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
        guard self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }
        self.viewModel.userInterfaceStyleDidChange()
    }
    
    // MARK: - Actions
    @IBAction private func projectButtonTapped(_ sender: Any) {
        self.viewModel.projectButtonTapped()
    }
    
    @IBAction private func taskURLTextFieldDidChange(_ sender: UITextField) {
        self.viewModel.taskURLDidChange(value: sender.text)
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        self.viewModel.viewRequestedToSave()
    }
    
    @IBAction private func saveWithFillingCheckboxTapped(_ sender: CheckBoxButton) {
        self.viewModel.saveWithFillingCheckboxTapped(isActive: sender.isActive)
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel?.viewHasBeenTapped()
    }
    
    @objc private func dayTextFieldDidChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(day: sender.date)
    }
    
    @objc private func startAtDateTextFieldDidChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(startAtDate: sender.date)
    }
    
    @objc private func endAtDateTextFieldDidChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(endAtDate: sender.date)
    }
}

// MARK: - UICollectionViewDelegate
extension WorkTimeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(TagCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        self.viewModel.configure(cell, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.viewSelectedTag(at: indexPath)
    }
}

// MARK: - UICollectionViewDataSource
extension WorkTimeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.viewRequestedForNumberOfTags()
    }
}

// MARK: - UITextViewDelegate
extension WorkTimeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.taskNameDidChange(value: textView.text)
        self.setContentOffset(animated: false)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.focusedView = textView
        return true
    }
}

// MARK: - UITextFieldDelegate
extension WorkTimeViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return !(textField === self.dayTextField
            || textField === self.startAtDateTextField
            || textField === self.endAtDateTextField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.focusedView = textField
    }
}

// MARK: - WorkTimeViewModelOutput
extension WorkTimeViewController: WorkTimeViewModelOutput {
    func setUp() {
        self.setUpTagsCollectionView()
        self.setUpActivityIndicator()
        self.setUpSaveButton()
        self.setUpConstraints()
        self.setUpProjectButton()
        self.setUpDayPicker()
        self.setUpDayTextField()
        self.setUpStartsAtPicker()
        self.setUpStartAtTextField()
        self.setUpEndsAtPicker()
        self.setUpEndAtTextField()
        self.setUpBodyTextView()
        self.setUpTaskTextField()
    }
    
    func setBodyView(isHidden: Bool) {
        self.bodyView.set(isHidden: isHidden)
    }
    
    func setTaskURLView(isHidden: Bool) {
        self.taskURLView.set(isHidden: isHidden)
    }
    
    func setBody(text: String) {
        self.bodyTextView.text = text
    }
    
    func setTask(urlString: String) {
        self.taskURLTextField.text = urlString
    }
    
    func setSaveWithFilling(isHidden: Bool) {
        self.saveWithFillingView.set(isHidden: isHidden)
    }
    
    func setSaveWithFilling(isChecked: Bool) {
        self.saveWithFillingCheckbox.isActive = isChecked
    }
    
    func setSaveButton(isEnabled: Bool) {
        self.saveButton.setWithAnimation(isEnabled: isEnabled)
    }
    
    func reloadTagsView() {
        self.tagsCollectionView.reloadData()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setMinimumDateForTypeEndAtDate(minDate: Date) {
        self.endAtDatePicker?.minimumDate = minDate
    }
    
    func updateDay(with date: Date, dateString: String) {
        self.dayTextField.text = dateString
        self.dayPicker?.date = date
    }
    
    func updateStartAtDate(with date: Date, dateString: String) {
        self.startAtDateTextField.text = dateString
        self.startAtDatePicker?.date = date
    }
    
    func updateEndAtDate(with date: Date, dateString: String) {
        self.endAtDateTextField.text = dateString
        self.endAtDatePicker?.date = date
    }
    
    func updateProject(name: String, color: UIColor) {
        self.projectTitleLabel.text = name
        self.projectColorView.backgroundColor = color
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.activityIndicator.set(isAnimating: !isHidden)
    }
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        guard self.isViewLoaded else { return }
        if keyboardState == .hidden {
            self.focusedView = nil
        }
        self.setBottomContentInset(keyboardHeight: keyboardState.keyboardHeight)
        self.setContentOffset(animated: true)
    }
    
    func setTagsCollectionView(isHidden: Bool) {
        self.tagsCollectionView.set(isHidden: isHidden)
    }
    
    func setProject(isHighlighted: Bool) {
        self.set(self.projectView, isHighlighted: isHighlighted)
    }
    
    func setDay(isHighlighted: Bool) {
        self.set(self.dayTextField, isHighlighted: isHighlighted)
    }
    
    func setStartsAt(isHighlighted: Bool) {
        self.set(self.startAtDateTextField, isHighlighted: isHighlighted)
    }
    
    func setEndsAt(isHighlighted: Bool) {
        self.set(self.endAtDateTextField, isHighlighted: isHighlighted)
    }
    
    func setBody(isHighlighted: Bool) {
        self.set(self.bodyTextView, isHighlighted: isHighlighted)
    }
    
    func setTaskURL(isHighlighted: Bool) {
        self.set(self.taskURLTextField, isHighlighted: isHighlighted)
    }
}

// MARK: - WorkTimeViewControllerType
extension WorkTimeViewController: WorkTimeViewControllerType {
    func configure(viewModel: WorkTimeViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension WorkTimeViewController {
    private func setUpActivityIndicator() {
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.setActivityIndicator(isHidden: true)
    }
    
    private func setUpProjectButton() {
        self.projectView.setTextFieldAppearance()
    }
    
    private func setUpDayPicker() {
        self.dayPicker = UIDatePicker()
        self.dayPicker.datePickerMode = .date
        self.dayPicker.addTarget(self, action: #selector(self.dayTextFieldDidChanged), for: .valueChanged)
    }
    
    private func setUpStartsAtPicker() {
        self.setUpTimePicker(&self.startAtDatePicker, selector: #selector(self.startAtDateTextFieldDidChanged))
    }
    
    private func setUpEndsAtPicker() {
        self.setUpTimePicker(&self.endAtDatePicker, selector: #selector(self.endAtDateTextFieldDidChanged))
    }
    
    private func setUpTimePicker(_ picker: inout UIDatePicker?, selector: Selector) {
        picker = UIDatePicker()
        picker?.datePickerMode = .time
        picker?.minuteInterval = 5
        picker?.addTarget(self, action: selector, for: .valueChanged)
    }
    
    private func setUpDayTextField() {
        self.dayTextField.inputView = self.dayPicker
        self.dayTextField.delegate = self
        self.dayTextField.setTextFieldAppearance()
    }
    
    private func setUpStartAtTextField() {
        self.startAtDateTextField.inputView = self.startAtDatePicker
        self.startAtDateTextField.delegate = self
        self.startAtDateTextField.setTextFieldAppearance()
    }
    
    private func setUpEndAtTextField() {
        self.endAtDateTextField.inputView = self.endAtDatePicker
        self.endAtDateTextField.delegate = self
        self.endAtDateTextField.setTextFieldAppearance()
    }
    
    private func setUpBodyTextView() {
        self.bodyTextView.setTextFieldAppearance()
    }
    
    private func setUpTaskTextField() {
        self.taskURLTextField.delegate = self
        self.taskURLTextField.setTextFieldAppearance()
    }
    
    private func setUpTagsCollectionView() {
        self.tagsCollectionView.register(TagCollectionViewCell.self)
        self.tagsCollectionView.delegate = self
        self.tagsCollectionView.dataSource = self
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
