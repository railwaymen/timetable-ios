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
    func userSelectedCell(at indexPath: IndexPath)
    func closeButtonTapped()
}

class ProfileViewModel {
    private weak var userInterface: ProfileViewModelOutput?
    private weak var coordinator: ProfileCoordinatorDelegate?
    private let apiClient: ApiClientUsersType
    private let accessService: AccessServiceLoginType
    private let errorHandler: ErrorHandlerType
    
    private weak var errorViewModel: ErrorViewModelParentType?
    
    // MARK: - Initialization
    init(
        userInterface: ProfileViewModelOutput?,
        coordinator: ProfileCoordinatorDelegate,
        apiClient: ApiClientUsersType,
        accessService: AccessServiceLoginType,
        errorHandler: ErrorHandlerType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.accessService = accessService
        self.errorHandler = errorHandler
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
            cellView.configure(text: R.string.localizable.profileButtonLogout())
        }
    }
    
    func userSelectedCell(at indexPath: IndexPath) {
        guard let cell = Cell(indexPath: indexPath) else { return }
        switch cell {
        case .logout:
            self.accessService.closeSession()
            self.coordinator?.userProfileDidLogoutUser()
        }
    }
    
    func closeButtonTapped() {
        self.coordinator?.viewDidRequestToFinish()
    }
}

// MARK: - Private
extension ProfileViewModel {
//    private func fetchProfile() {
//        guard let userID = self.accessService.getLastLoggedInUserID() else { return }
//        self.userInterface?.setActivityIndicator(isHidden: false)
//        self.apiClient.fetchUserProfile(forID: userID) { [weak self] result in
//            self?.userInterface?.setActivityIndicator(isHidden: true)
//            switch result {
//            case let .success(profile):
//                self?.handleFetchSuccess(profile: profile)
//            case let .failure(error):
//                self?.handleFetch(error: error)
//            }
//        }
//    }
//
//    private func handleFetchSuccess(profile: UserDecoder) {
//        self.userInterface?.showScrollView()
//    }
//
//    private func handleFetch(error: Error) {
//        if let error = error as? ApiClientError {
//            if error.type == .unauthorized {
//                self.errorHandler.throwing(error: error)
//            } else {
//                self.errorViewModel?.update(error: error)
//            }
//        } else {
//            self.errorViewModel?.update(error: UIError.genericError)
//            self.errorHandler.throwing(error: error)
//        }
//        self.userInterface?.showErrorView()
//    }
}
