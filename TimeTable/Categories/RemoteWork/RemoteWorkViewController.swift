//
//  RemoteWorkViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias RemoteWorkViewControllerable = (UIViewController & RemoteWorkViewModelOutput & RemoteWorkViewControllerType)

protocol RemoteWorkViewControllerType: class {
    func configure(viewModel: RemoteWorkViewModelType)
}

class RemoteWorkViewController: UIViewController {
    private var viewModel: RemoteWorkViewModelType!
    
    // MARK: - Overridden
    override func loadView() {
        super.loadView()
        self.viewModel.loadView()
    }
    
    // MARK: - Actions
    @objc private func addNewRecordTapped() {
        self.viewModel.addNewRecordTapped()
    }
    
    @objc private func profileButtonTapped() {
        self.viewModel.profileButtonTapped()
    }
}

// MARK: - RemoteWorkViewModelOutput
extension RemoteWorkViewController: RemoteWorkViewModelOutput {
    func setUp() {
        self.setUpTitle()
        self.setUpBarButtons()
    }
}

// MARK: - RemoteWorkViewControllerType
extension RemoteWorkViewController: RemoteWorkViewControllerType {
    func configure(viewModel: RemoteWorkViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension RemoteWorkViewController {
    private func setUpTitle() {
        self.title = R.string.localizable.remotework_title()
    }
    
    private func setUpBarButtons() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let addImageView = self.buildImageView(image: .plus, action: #selector(self.addNewRecordTapped))
        let profileImageView = self.buildImageView(image: .profile, action: #selector(self.profileButtonTapped))
        navigationBar.setLargeTitleRightViews([addImageView, profileImageView])
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
