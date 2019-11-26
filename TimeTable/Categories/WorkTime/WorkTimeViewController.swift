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
    @IBOutlet private var bodyTextField: UITextField!
    @IBOutlet private var taskURLTextField: UITextField!
    @IBOutlet private var tagsCollectionView: UICollectionView!
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
    
    @IBAction private func taskTextFieldDidChange(_ sender: UITextField) {
        self.viewModel.taskNameDidChange(value: sender.text)
    }
    
    @IBAction private func taskURLTextFieldDidChange(_ sender: UITextField) {
        self.viewModel.taskURLDidChange(value: sender.text)
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        self.viewModel.viewRequestedToSave()
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel?.viewHasBeenTapped()
    }
    
    @IBAction private func dayTextFieldDidBegin(_ sender: UITextField) {
        self.viewModel.setDefaultDay()
    }
    
    @objc private func dayTextFieldDidChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(day: sender.date)
    }
    
    @IBAction private func startAtDateTextFieldDidBegin(_ sender: UITextField) {
        self.viewModel.setDefaultStartAtDate()
    }

    @objc private func startAtDateTextFieldDidChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(startAtDate: sender.date)
    }
    
    @IBAction private func endAtDateTextFieldDidBegin(_ sender: UITextField) {
        self.viewModel.setDefaultEndAtDate()
    }    
    
    @objc private func endAtDateTextFieldDidChanged(_ sender: UIDatePicker) {
        self.viewModel.viewChanged(endAtDate: sender.date)
    }
}

// MARK: - UICollectionViewDelegate
extension WorkTimeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.reuseIdentifier,
            for: indexPath) as? TagCollectionViewCellable else {
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
        self.tagsCollectionView.reloadData()
    }
    
    func setUp(isLunch: Bool, allowsTask: Bool, body: String?, urlString: String?) {
        let systemItem: UIBarButtonItem.SystemItem
        if #available(iOS 13, *) {
            systemItem = .close
        } else {
            systemItem = .cancel
        }
        let closeButton = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(self.cancelButtonTapped))
        self.navigationItem.setRightBarButton(closeButton, animated: false)
        
        self.bodyTextField.isHidden = isLunch
        self.bodyTextField.text = body
        
        self.taskURLTextField.isHidden = !allowsTask || isLunch
        self.taskURLTextField.text = urlString
        
        self.dayPicker = UIDatePicker()
        self.dayPicker.datePickerMode = .date
        self.dayPicker.addTarget(self, action: #selector(self.dayTextFieldDidChanged), for: .valueChanged)
        self.dayTextField.inputView = self.dayPicker
        
        self.startAtDatePicker = UIDatePicker()
        self.startAtDatePicker.datePickerMode = .time
        self.startAtDatePicker.minuteInterval = 5
        self.startAtDatePicker.addTarget(self, action: #selector(self.startAtDateTextFieldDidChanged), for: .valueChanged)
        self.startAtDateTextField.inputView = self.startAtDatePicker

        self.endAtDatePicker = UIDatePicker()
        self.endAtDatePicker.datePickerMode = .time
        self.endAtDatePicker.minuteInterval = 5
        self.endAtDatePicker.addTarget(self, action: #selector(self.endAtDateTextFieldDidChanged), for: .valueChanged)
        self.endAtDateTextField.inputView = self.endAtDatePicker
        
        self.tagsCollectionView.delegate = self
        self.tagsCollectionView.dataSource = self
        
        self.setUpActivityIndicator()
    }
    
    func dismissView() {
        self.dismiss(animated: true)
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
        isHidden ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = isHidden
    }
    
    func setBottomContentInset(_ height: CGFloat) {
        guard self.viewIfLoaded != nil else { return }
        self.scrollView.contentInset.bottom = height
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
}
