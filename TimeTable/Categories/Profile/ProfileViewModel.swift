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
    func viewRequestedForLogout()
}

class ProfileViewModel {
    private weak var userInterface: ProfileViewModelOutput?
    private weak var coordinator: ProfileCoordinatorDelegate?
    private let apiClient: ApiClientUsersType
    private let accessService: AccessServiceUserIDType
    private let coreDataStack: CoreDataStackUserType
    private let errorHandler: ErrorHandlerType
    
    private weak var errorViewModel: ErrorViewModelParentType?
    
    // MARK: - Initialization
    init(
        userInterface: ProfileViewModelOutput?,
        coordinator: ProfileCoordinatorDelegate,
        apiClient: ApiClientUsersType,
        accessService: AccessServiceUserIDType,
        coreDataStack: CoreDataStackUserType,
        errorHandler: ErrorHandlerType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.accessService = accessService
        self.coreDataStack = coreDataStack
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
    
    func viewRequestedForLogout() {
        guard let userIdentifier = self.accessService.getLastLoggedInUserIdentifier() else { return }
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.coreDataStack.deleteUser(forIdentifier: userIdentifier) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .success:
                self?.coordinator?.userProfileDidLogoutUser()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
}

// MARK: - Private
extension ProfileViewModel {
    private func fetchProfile() {
        guard let userIdentifier = self.accessService.getLastLoggedInUserIdentifier() else { return }
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.apiClient.fetchUserProfile(forIdetifier: userIdentifier) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .success(let profile):
                self?.handleFetchSuccess(profile: profile)
            case .failure(let error):
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
            self.errorViewModel?.update(error: error)
        } else {
            self.errorViewModel?.update(error: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.userInterface?.showErrorView()
    }
}
