//
//  WorkTimeContainerViewController.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 23/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimeContainerViewControllerable = UIViewController & WorkTimeContainerViewControllerType & WorkTimeContainerViewModelOutput

protocol WorkTimeContainerViewControllerType: class {
    func configure(viewModel: WorkTimeContainerViewModelType)
}

class WorkTimeContainerViewController: UIViewController {
    @IBOutlet private var formView: UIView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: WorkTimeContainerViewModelType!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let viewController = segue.destination as? WorkTimeViewControllerable {
            self.viewModel.configure(viewController)
        }
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        self.viewModel.closeButtonTapped()
    }
}

// MARK: - WorkTimeContainerViewModelOutput
extension WorkTimeContainerViewController: WorkTimeContainerViewModelOutput {
    func setUp(withTitle title: String) {
        self.setUpNavigationBarItems(title: title)
        self.setUpActivityIndicator()
    }
    
    func showForm() {
        UIView.transition(
            with: self.formView,
            duration: 0.3,
            animations: { [weak self] in
                self?.formView.set(isHidden: false)
        })
    }
    
    func hideAllContainerViews() {
        self.formView.set(isHidden: true)
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
        if #available(iOS 13, *) {
            self.activityIndicator.style = .medium
        } else {
            self.activityIndicator.style = .gray
        }
        self.activityIndicator.hidesWhenStopped = true
        self.setActivityIndicator(isHidden: true)
    }
    
    private func setUpNavigationBarItems(title: String) {
        self.title = title
        let closeButton = UIBarButtonItem(barButtonSystemItem: .closeButton, target: self, action: #selector(self.closeButtonTapped))
        self.navigationItem.setRightBarButton(closeButton, animated: false)
    }
}
