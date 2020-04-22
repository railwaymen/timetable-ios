//
//  VacationsViewContorller.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias VacationsViewContorllerable = (UIViewController & VacationsViewContorllerType & VacationsViewModelOutput)

protocol VacationsViewContorllerType: class {
    func configure(viewModel: VacationsViewModelType)
}

class VacationsViewContorller: UIViewController {
    private var viewModel: VacationsViewModelType!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func profileButtonTapped() {
        self.viewModel.viewRequestForProfileView()
    }
}

// MARK: - VacationsViewModelOutput
extension VacationsViewContorller: VacationsViewModelOutput {
    func setUpView() {
        self.setUpNavigationItem()
        self.setUpBarButtons()
    }
}

// MARK: - VacationsViewContorllerType
extension VacationsViewContorller: VacationsViewContorllerType {
    func configure(viewModel: VacationsViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension VacationsViewContorller {
    private func setUpNavigationItem() {
        self.title = R.string.localizable.tabbar_title_vacations()
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
