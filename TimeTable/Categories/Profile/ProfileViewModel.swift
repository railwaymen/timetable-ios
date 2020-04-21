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
    func update(firstName: String, lastName: String, email: String)
    func setActivityIndicator(isHidden: Bool)
    func showScrollView()
    func showErrorView()
}

protocol ProfileViewModelType: class {
    func viewDidLoad()
    func configure(_ view: ErrorViewable)
    func logoutButtonTapped()
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

// MARK: - ProfileViewModelType
extension ProfileViewModel: ProfileViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUp()
        self.fetchProfile()
    }
    
    func configure(_ view: ErrorViewable) {
        let viewModel = ErrorViewModel(userInterface: view, error: UIError.genericError) { [weak self] in
            self?.fetchProfile()
        }
        view.configure(viewModel: viewModel)
        self.errorViewModel = viewModel
    }
    
    func logoutButtonTapped() {
        self.accessService.closeSession()
        self.coordinator?.userProfileDidLogoutUser()
    }
}

// MARK: - Private
extension ProfileViewModel {
    private func fetchProfile() {
        guard let userID = self.accessService.getLastLoggedInUserID() else { return }
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.apiClient.fetchUserProfile(forID: userID) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case let .success(profile):
                self?.handleFetchSuccess(profile: profile)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    private func handleFetchSuccess(profile: UserDecoder) {
        self.userInterface?.update(firstName: profile.firstName, lastName: profile.lastName, email: profile.email)
        self.userInterface?.showScrollView()
    }
    
    private func handleFetch(error: Error) {
        if let error = error as? ApiClientError {
            if error.type == .unauthorized {
                self.errorHandler.throwing(error: error)
            } else {
                self.errorViewModel?.update(error: error)
            }
        } else {
            self.errorViewModel?.update(error: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.userInterface?.showErrorView()
    }
}
