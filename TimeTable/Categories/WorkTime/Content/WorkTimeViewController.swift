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
    @IBOutlet private var projectButton: AttributedButton!
    @IBOutlet private var dayTextField: UITextField!
    @IBOutlet private var startAtDateTextField: UITextField!
    @IBOutlet private var endAtDateTextField: UITextField!
    @IBOutlet private var tagsCollectionView: UICollectionView!
    @IBOutlet private var bodyView: UIView!
    @IBOutlet private var bodyTextView: UITextView!
    @IBOutlet private var taskURLView: UIView!
    @IBOutlet private var taskURLTextField: UITextField!
    @IBOutlet private var saveButton: AttributedButton!
    @IBOutlet private var saveWithFillingButton: AttributedButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var dayPicker: UIDatePicker!
    private var startAtDatePicker: UIDatePicker!
    private var endAtDatePicker: UIDatePicker!
    private var viewModel: WorkTimeViewModelType!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
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
    
    @IBAction private func saveWithFillingButtonTapped(_ sender: UIButton) {
        self.viewModel.viewRequestedToSaveWithFilling()
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
}

// MARK: - WorkTimeViewModelOutput
extension WorkTimeViewController: WorkTimeViewModelOutput {
    func setUp() {
        self.setUpTagsCollectionView()
        self.setUpActivityIndicator()
        self.setUpSaveButtons()
        
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
    
    func setSaveWithFillingButton(isHidden: Bool) {
        self.saveWithFillingButton.set(isHidden: isHidden)
    }
    
    func setSaveButtons(isEnabled: Bool) {
        self.saveButton.isEnabled = isEnabled
        self.saveWithFillingButton.isEnabled = isEnabled
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
        self.startAtDatePicker?.date = date
    }
    
    func updateStartAtDate(with date: Date, dateString: String) {
        self.startAtDateTextField.text = dateString
        self.startAtDatePicker?.date = date
    }
    
    func updateEndAtDate(with date: Date, dateString: String) {
        self.endAtDateTextField.text = dateString
        self.endAtDatePicker?.date = date
    }
    
    func updateProject(name: String) {
        self.projectButton.setTitle(name, for: UIControl.State())
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.activityIndicator.set(isAnimating: !isHidden)
    }
    
    func setBottomContentInset(_ height: CGFloat) {
        guard self.viewIfLoaded != nil else { return }
        let bottomInset = max(0, height - self.scrollView.safeAreaInsets.bottom)
        self.scrollView.contentInset.bottom = bottomInset
        self.scrollView.scrollIndicatorInsets.bottom = bottomInset
    }
    
    func setTagsCollectionView(isHidden: Bool) {
        self.tagsCollectionView.set(isHidden: isHidden)
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
        if #available(iOS 13, *) {
            self.activityIndicator.style = .large
        } else {
            self.activityIndicator.style = .gray
        }
        self.activityIndicator.hidesWhenStopped = true
        self.setActivityIndicator(isHidden: true)
    }
    
    private func setUpProjectButton() {
        self.projectButton.setTextFieldAppearance()
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
    
    private func setUpSaveButtons() {
        self.saveButton.setBackgroundColor(.enabledButton, forState: .normal)
        self.saveButton.setBackgroundColor(.disabledButton, forState: .disabled)
        self.saveWithFillingButton.setTitleColor(.enabledButton, for: .normal)
        self.saveWithFillingButton.setTitleColor(.disabledButton, for: .disabled)
    }
}
