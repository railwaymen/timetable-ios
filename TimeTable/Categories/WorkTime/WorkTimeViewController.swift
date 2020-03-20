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
    @objc private func cancelButtonTapped() {
        self.viewModel.viewRequestedToFinish()
    }
    
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
        guard let cell = collectionView.dequeueReusableCell(TagCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
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

// MARK: - WorkTimeViewModelOutput
extension WorkTimeViewController: WorkTimeViewModelOutput {
    func setUp(withTitle title: String) {
        self.setUpNavigationBarItems(title: title)
        self.setUpTagsCollectionView()
        self.setUpActivityIndicator()
        
        self.setUpDayPicker()
        self.dayTextField.inputView = self.dayPicker
        
        self.setUpStartsAtPicker()
        self.startAtDateTextField.inputView = self.startAtDatePicker

        self.setUpEndsAtPicker()
        self.endAtDateTextField.inputView = self.endAtDatePicker
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
        self.activityIndicator.set(isHidden: isHidden)
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
        self.setActivityIndicator(isHidden: true)
    }
    
    private func setUpNavigationBarItems(title: String) {
        self.title = title
        let closeButton = UIBarButtonItem(barButtonSystemItem: .closeButton, target: self, action: #selector(self.cancelButtonTapped))
        self.navigationItem.setRightBarButton(closeButton, animated: false)
    }
    
    private func setUpDayPicker() {
        self.dayPicker = UIDatePicker()
        self.dayPicker.datePickerMode = .date
        self.dayPicker.addTarget(self, action: #selector(self.dayTextFieldDidChanged), for: .valueChanged)
    }
    
    private func setUpStartsAtPicker() {
        self.startAtDatePicker = UIDatePicker()
        self.startAtDatePicker.datePickerMode = .time
        self.startAtDatePicker.minuteInterval = 5
        self.startAtDatePicker.addTarget(self, action: #selector(self.startAtDateTextFieldDidChanged), for: .valueChanged)
    }
    
    private func setUpEndsAtPicker() {
        self.endAtDatePicker = UIDatePicker()
        self.endAtDatePicker.datePickerMode = .time
        self.endAtDatePicker.minuteInterval = 5
        self.endAtDatePicker.addTarget(self, action: #selector(self.endAtDateTextFieldDidChanged), for: .valueChanged)
    }
    
    private func setUpTagsCollectionView() {
        self.tagsCollectionView.register(TagCollectionViewCell.self)
        self.tagsCollectionView.delegate = self
        self.tagsCollectionView.dataSource = self
    }
}
