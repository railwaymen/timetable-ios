//
//  NewVacationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol NewVacationViewModelType: class {
    func loadView()
    func closeButtonTapped()
    func numberOfTypes() -> Int
    func titleOfType(for row: Int) -> String?
    func viewChanged(startAtDate date: Date)
    func viewChanged(endAtDate date: Date)
    func viewSelectedType(at row: Int)
    func viewHasBeenTapped()
}

protocol NewVacationViewModelOutput: class {
    func setUp()
    func setActivityIndicator(isHidden: Bool)
    func setNote(text: String)
    func setMinimumDateForEndDate(minDate: Date)
    func updateStartDate(with date: Date, dateString: String)
    func updateEndAtDate(with date: Date, dateString: String)
    func updateType(name: String)
    func setSaveButton(isEnabled: Bool)
    func setBottomContentInset(_ height: CGFloat)
    func dismissKeyboard()
}

class NewVacationViewModel {
    private weak var userInterface: NewVacationViewModelOutput?
    private weak var coordinator: NewVacationCoordinatorDelegate?
    private let apiClient: ApiClientVacationType
    private let notificationCenter: NotificationCenterType
    private let errorHandler: ErrorHandlerType
    
    // MARK: - Initialization
    init(
        userInterface: NewVacationViewModelOutput,
        apiClient: ApiClientVacationType,
        errorHandler: ErrorHandlerType,
        notificationCenter: NotificationCenterType,
        coordinator: NewVacationCoordinatorDelegate
    ) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.notificationCenter = notificationCenter
        self.coordinator = coordinator
        
        self.setUpNotification()
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc func keyboardFrameWillChange(_ notification: NSNotification) {
        let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight = userInfo?.cgRectValue.size.height else { return }
        self.userInterface?.setBottomContentInset(keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        self.userInterface?.setBottomContentInset(0)
    }
}

// MARK: - NewVacationViewModelType
extension NewVacationViewModel: NewVacationViewModelType {
    func loadView() {
        self.userInterface?.setUp()
        self.userInterface?.setNote(text: "")
        let date = Date()
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        self.userInterface?.updateStartDate(with: date, dateString: dateString)
        self.userInterface?.updateEndAtDate(with: date, dateString: dateString)
        self.userInterface?.setSaveButton(isEnabled: false)
    }
    
    func closeButtonTapped() {
        self.coordinator?.finishFlow()
    }
    
    func numberOfTypes() -> Int {
        return 5
    }
    
    func titleOfType(for row: Int) -> String? {
        return "type \(row)"
    }
    
    func viewChanged(startAtDate date: Date) {
        
    }
    
    func viewChanged(endAtDate date: Date) {
        
    }
    
    func viewSelectedType(at row: Int) {
        self.userInterface?.updateType(name: "type \(row)")
    }
    
    func viewHasBeenTapped() {
        self.userInterface?.dismissKeyboard()
    }
}

// MARK: - Private
extension NewVacationViewModel {
    private func setUpNotification() {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardFrameWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
}
