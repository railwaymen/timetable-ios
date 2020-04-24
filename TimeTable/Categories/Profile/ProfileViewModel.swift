//
//  ProfileViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 17/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ProfileViewModelOutput: class {
    func setUp()
}

protocol ProfileViewModelType: class {
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func cellType(for indexPath: IndexPath) -> ProfileViewModel.CellType?
    func configure(_ cell: ProfileButtonCellConfigurationInterface, for indexPath: IndexPath)
    func configure(_ headerView: ProfileHeaderViewConfigurationInterface)
    func userSelectedCell(at indexPath: IndexPath)
    func closeButtonTapped()
}

class ProfileViewModel {
    private weak var userInterface: ProfileViewModelOutput?
    private weak var coordinator: ProfileCoordinatorDelegate?
    private let contentProvider: ProfileContentProviderViewModelInterface
    
    private weak var errorViewModel: ErrorViewModelParentType?
    private weak var headerView: ProfileHeaderViewConfigurationInterface?
    
    // MARK: - Initialization
    init(
        userInterface: ProfileViewModelOutput?,
        coordinator: ProfileCoordinatorDelegate,
        contentProvider: ProfileContentProviderViewModelInterface
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
    }
}

// MARK: - Structures
extension ProfileViewModel {
    enum CellType {
        case button
    }
    
    enum Cell {
        case logout
        
        var cellType: CellType {
            switch self {
            case .logout:
                return .button
            }
        }
        
        init?(indexPath: IndexPath) {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                self = .logout
            default:
                return nil
            }
        }
    }
}

// MARK: - ProfileViewModelType
extension ProfileViewModel: ProfileViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUp()
        self.contentProvider.updateUserData { [weak self] userData in
            self?.headerView?.configure(
                name: userData.fullName,
                email: userData.email)
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func cellType(for indexPath: IndexPath) -> CellType? {
        guard let cell = Cell(indexPath: indexPath) else { return nil }
        return cell.cellType
    }
    
    func configure(_ cellView: ProfileButtonCellConfigurationInterface, for indexPath: IndexPath) {
        guard let cell = Cell(indexPath: indexPath) else { return }
        switch cell {
        case .logout:
            cellView.configure(text: R.string.localizable.profile_logout_btn())
        }
    }
    
    func configure(_ headerView: ProfileHeaderViewConfigurationInterface) {
        self.headerView = headerView
        let userData = self.contentProvider.getUserData()
        headerView.configure(
            name: userData?.fullName ?? "Your name",
            email: userData?.email ?? "")
    }
    
    func userSelectedCell(at indexPath: IndexPath) {
        guard let cell = Cell(indexPath: indexPath) else { return }
        switch cell {
        case .logout:
            self.contentProvider.closeSession()
            self.coordinator?.userProfileDidLogoutUser()
        }
    }
    
    func closeButtonTapped() {
        self.coordinator?.viewDidRequestToFinish()
    }
}
