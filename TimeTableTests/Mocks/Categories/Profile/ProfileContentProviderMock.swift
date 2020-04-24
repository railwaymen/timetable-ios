//
//  ProfileContentProviderMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProfileContentProviderMock {
    
    // MARK: - ProfileContentProviderViewModelInterface
    var getUserDataReturnValue: UserDecoder?
    private(set) var getUserDataParams: [GetUserDataParams] = []
    struct GetUserDataParams {}
    
    private(set) var updateUserDataParams: [UpdateUserDataParams] = []
    struct UpdateUserDataParams {
        let successCompletion: ProfileContentProviderViewModelInterface.UpdateUserDataCompletion
    }
    
    private(set) var closeSessionParams: [CloseSessionParams] = []
    struct CloseSessionParams {}
}

// MARK: - ProfileContentProviderViewModelInterface
extension ProfileContentProviderMock: ProfileContentProviderViewModelInterface {
    func getUserData() -> UserDecoder? {
        self.getUserDataParams.append(GetUserDataParams())
        return self.getUserDataReturnValue
    }
    
    func updateUserData(successCompletion: @escaping ProfileContentProviderViewModelInterface.UpdateUserDataCompletion) {
        self.updateUserDataParams.append(UpdateUserDataParams(successCompletion: successCompletion))
    }
    
    func closeSession() {
        self.closeSessionParams.append(CloseSessionParams())
    }
}
