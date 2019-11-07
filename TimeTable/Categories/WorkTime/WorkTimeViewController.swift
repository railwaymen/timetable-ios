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
    func configure(viewModel: WorkTimeViewModelType, notificationCenter: NotificationCenterType?)
}

class WorkTimeViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var projectButton: AttributedButton!
    @IBOutlet private var dayTextField: UITextField!
    @IBOutlet private var startAtDateTextField: UITextField!
    @IBOutlet private var endAtDateTextField: UITextField!
    @IBOutlet private var bodyTextField: UITextField!
    @IBOutlet private var taskURLTextField: UITextField!
    @IBOutlet private var tagsCollectionView: UICollectionView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var dayPicker: UIDatePicker!
    private var startAtDatePicker: UIDatePicker!
    private var endAtDatePicker: UIDatePicker!
    private var viewModel: WorkTimeViewModelType!
    private var notificationCenter: NotificationCenterType?
    
    // MARK: - Deinitialization
    deinit {
        notificationCenter?.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Action
    @objc private func cancelButtonTapped() {
        viewModel.viewRequestedToFinish()
    }
    
    @IBAction private func projectButtonTapped(_ sender: Any) {
        viewModel.projectButtonTapped()
    }
    
    @IBAction private func taskTextFieldDidChange(_ sender: UITextField) {
        viewModel.taskNameDidChange(value: sender.text)
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
    
    @objc private func keyboardFrameWillChange(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height ?? 0
        scrollView.contentInset.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0
    }
    
    // MARK: - Private
    private func setUpActivityIndicator() {
        if #available(iOS 13, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        setActivityIndicator(isHidden: true)
    }
}

// MARK: - UICollectionViewDelegate
extension WorkTimeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? TagCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        guard let tag = self.viewModel.viewRequestedForTag(at: indexPath) else { return UICollectionViewCell() }
        let isSelected = self.viewModel.isTagSelected(at: indexPath)
        let viewModel = TagCollectionViewCellViewModel(userInterface: cell,
                                                       projectTag: tag,
                                                       isSelected: isSelected)
        cell.configure(viewModel: viewModel)
        
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

// MARK: - WorkTimeViewModelOutput
extension WorkTimeViewController: WorkTimeViewModelOutput {
    func reloadTagsView() {
        tagsCollectionView.reloadData()
    }
    
    func setUp(isLunch: Bool, allowsTask: Bool, body: String?, urlString: String?) {
        notificationCenter?.addObserver(self,
                                        selector: #selector(self.keyboardFrameWillChange),
                                        name: UIResponder.keyboardWillChangeFrameNotification,
                                        object: nil)
        notificationCenter?.addObserver(self,
                                        selector: #selector(self.keyboardWillHide),
                                        name: UIResponder.keyboardWillHideNotification,
                                        object: nil)
        let systemItem: UIBarButtonItem.SystemItem
        if #available(iOS 13, *) {
            systemItem = .close
        } else {
            systemItem = .cancel
        }
        let closeButton = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(cancelButtonTapped))
        navigationItem.setRightBarButton(closeButton, animated: false)
        
        bodyTextField.isHidden = isLunch
        bodyTextField.text = body
        
        taskURLTextField.isHidden = !allowsTask || isLunch
        taskURLTextField.text = urlString
        
        dayPicker = UIDatePicker()
        dayPicker.datePickerMode = .date
        dayPicker.addTarget(self, action: #selector(dayTextFieldDidChanged), for: .valueChanged)
        dayTextField.inputView = dayPicker
        
        startAtDatePicker = UIDatePicker()
        startAtDatePicker.datePickerMode = .time
        startAtDatePicker.minuteInterval = 5
        startAtDatePicker.addTarget(self, action: #selector(startAtDateTextFieldDidChanged), for: .valueChanged)
        startAtDateTextField.inputView = startAtDatePicker

        endAtDatePicker = UIDatePicker()
        endAtDatePicker.datePickerMode = .time
        endAtDatePicker.minuteInterval = 5
        endAtDatePicker.addTarget(self, action: #selector(endAtDateTextFieldDidChanged), for: .valueChanged)
        endAtDateTextField.inputView = endAtDatePicker
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        setUpActivityIndicator()
    }
    
    func dismissView() {
        dismiss(animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setMinimumDateForTypeEndAtDate(minDate: Date) {
        endAtDatePicker?.minimumDate = minDate
    }
    
    func updateDay(with date: Date, dateString: String) {
        dayTextField.text = dateString
        startAtDatePicker?.date = date
    }
    
    func updateStartAtDate(with date: Date, dateString: String) {
        startAtDateTextField.text = dateString
        startAtDatePicker?.date = date
    }
    
    func updateEndAtDate(with date: Date, dateString: String) {
        endAtDateTextField.text = dateString
        endAtDatePicker?.date = date
    }
    
    func updateProject(name: String) {
        projectButton.setTitle(name, for: UIControl.State())
    }
    
    func setActivityIndicator(isHidden: Bool) {
        isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
        activityIndicator.isHidden = isHidden
    }
}

// MARK: - WorkTimeViewControllerType
extension WorkTimeViewController: WorkTimeViewControllerType {
    func configure(viewModel: WorkTimeViewModelType, notificationCenter: NotificationCenterType?) {
        self.viewModel = viewModel
        self.notificationCenter = notificationCenter
    }
}
