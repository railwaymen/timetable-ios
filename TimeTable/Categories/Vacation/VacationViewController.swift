//
//  VacationViewContorller.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias VacationViewControllerable = (UIViewController & VacationViewControllerType & VacationViewModelOutput)

protocol VacationViewControllerType: class {
    func configure(viewModel: VacationViewModelType)
}

class VacationViewController: UIViewController {
    private var viewModel: VacationViewModelType!

    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func profileButtonTapped() {
        self.viewModel.viewRequestForProfileView()
    }
}

// MARK: - VacationViewModelOutput
extension VacationViewController: VacationViewModelOutput {
    func setUpView() {
        self.setUpNavigationItem()
        self.setUpBarButtons()
    }
}

// MARK: - VacationViewControllerType
extension VacationViewController: VacationViewControllerType {
    func configure(viewModel: VacationViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension VacationViewController {
    private func setUpNavigationItem() {
        self.title = R.string.localizable.tabbar_title_vacation()
    }
    
    private func setUpBarButtons() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let profileImageView = self.buildImageView(image: .profile, action: #selector(self.profileButtonTapped))
        navigationBar.setLargeTitleRightViews([profileImageView])
    }
    
    private func buildImageView(image: UIImage?, action: Selector) -> UIImageView {
        let imageView = UIImageView(image: image)
        let tap = UITapGestureRecognizer(target: self, action: action)
        imageView.tintColor = .tint
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }
}
