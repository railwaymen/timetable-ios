//
//  WorkTimeContainerViewController.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 23/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimeContainerViewControllerable =
    UIViewController
    & WorkTimeContainerViewControllerType
    & WorkTimeContainerViewModelOutput

protocol WorkTimeContainerViewControllerType: class {
    func configure(viewModel: WorkTimeContainerViewModelType)
}

class WorkTimeContainerViewController: UIViewController {
    @IBOutlet private var formView: UIView!
    @IBOutlet private var errorView: ErrorView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: WorkTimeContainerViewModelType!
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let viewController = segue.destination as? WorkTimeViewControllerable else { return }
        self.viewModel.configure(viewController)
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        self.viewModel.closeButtonTapped()
    }
}

// MARK: - ContainerViewControllerType
extension WorkTimeContainerViewController: ContainerViewControllerType {
    var containedViews: [UIView] {
        [self.formView, self.errorView].compactMap { $0 }
    }
}

// MARK: - WorkTimeContainerViewModelOutput
extension WorkTimeContainerViewController: WorkTimeContainerViewModelOutput {
    func setUp(withTitle title: String) {
        self.viewModel.configure(self.errorView)
        self.setUpNavigationBarItems(title: title)
        self.setUpActivityIndicator()
    }
    
    func showForm() {
        self.showWithAnimation(view: self.formView, duration: Constants.defaultTrasitionDuration)
    }
    
    func showError() {
        self.showWithAnimation(view: self.errorView, duration: Constants.defaultTrasitionDuration)
    }
    
    func hideAllContainerViews() {
        self.hideAllContainedViews()
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.activityIndicator.set(isAnimating: !isHidden)
    }
}

// MARK: - WorkTimeContainerViewControllerType
extension WorkTimeContainerViewController: WorkTimeContainerViewControllerType {
    func configure(viewModel: WorkTimeContainerViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension WorkTimeContainerViewController {
    private func setUpActivityIndicator() {
        self.activityIndicator.style = .medium
        self.activityIndicator.hidesWhenStopped = true
        self.setActivityIndicator(isHidden: true)
    }
    
    private func setUpNavigationBarItems(title: String) {
        self.title = title
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .closeButton,
            target: self,
            action: #selector(self.closeButtonTapped))
        self.navigationItem.setRightBarButton(closeButton, animated: false)
    }
}
