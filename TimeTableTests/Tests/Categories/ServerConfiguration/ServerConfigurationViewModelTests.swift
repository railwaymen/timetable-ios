//
//  ServerConfigurationViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ServerConfigurationViewModelTests: XCTestCase {
    private var userInterfaceMock: ServerConfigurationViewControllerMock!
    private var coordinatorMock: CoordinatorMock!
    private var serverConfigurationManagerMock: ServerConfigurationManagerMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var notificationCenterMock: NotificationCenterMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = ServerConfigurationViewControllerMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.coordinatorMock = CoordinatorMock()
        self.serverConfigurationManagerMock = ServerConfigurationManagerMock()
        self.notificationCenterMock = NotificationCenterMock()
    }
}
 
// MARK: - viewDidLoad()
extension ServerConfigurationViewModelTests {
    func testViewDidLoadCallSetupViewOnTheUserInterface() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.last?.serverAddress, "")
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 0)
    }
}

// MARK: - viewWillAppear()
extension ServerConfigurationViewModelTests {
    func testViewWillAppear_nilURL_setsContinueButtonDisabled() {
        //Arrange
        let sut = self.buildSUT()
        sut.serverAddressDidChange(text: nil)
        //Act
        sut.viewWillAppear()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.last).isEnabled)
    }
    
    func testViewWillAppear_emptyURL_setsContinueButtonDisabled() {
        //Arrange
        let sut = self.buildSUT()
        sut.serverAddressDidChange(text: "")
        //Act
        sut.viewWillAppear()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.last).isEnabled)
    }
    
    func testViewWillAppear_invalidURL_setsContinueButtonDisabled() {
        //Arrange
        let sut = self.buildSUT()
        sut.serverAddressDidChange(text: " ")
        //Act
        sut.viewWillAppear()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.last).isEnabled)
    }
    
    func testViewWillAppear_validURL_setsContinueButtonEnabled() {
        //Arrange
        let sut = self.buildSUT()
        sut.serverAddressDidChange(text: "www.example.com")
        //Act
        sut.viewWillAppear()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.last).isEnabled)
    }
}

// MARK: - continueButtonTapped()
extension ServerConfigurationViewModelTests {
    func testViewRequestedToContinue_emptyServerAddress_throwsError() {
        //Arrange
        let sut = self.buildSUT()
        let expectedError = UIError.cannotBeEmpty(.serverAddressTextField)
        //Act
        sut.continueButtonTapped()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setActivityIndicatorParams.isEmpty)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? UIError, expectedError)
    }
    
    func testViewRequestedToContinue_invalidServerAddress_throwsError() {
        //Arrange
        let sut = self.buildSUT()
        sut.serverAddressDidChange(text: "##invalid_address")
        let expectedError = UIError.invalidFormat(.serverAddressTextField)
        //Act
        sut.continueButtonTapped()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setActivityIndicatorParams.isEmpty)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? UIError, expectedError)
    }
    
    func testViewRequestedToContinue_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let hostString = "www.example.com"
        sut.serverAddressDidChange(text: hostString)
        //Act
        sut.continueButtonTapped()
        //Assert
        XCTAssertEqual(self.coordinatorMock.serverConfigurationDidFinishParams.count, 0)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.last).isEnabled)
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithDefaultValues() throws {
        //Arrange
        let sut = self.buildSUT()
        let hostString = "www.example.com"
        sut.serverAddressDidChange(text: hostString)
        //Act
        sut.continueButtonTapped()
        self.serverConfigurationManagerMock.verifyParams.last?.completion(.success(Void()))
        //Assert
        let configuration = try XCTUnwrap(self.coordinatorMock.serverConfigurationDidFinishParams.last?.serverConfiguration)
        XCTAssertEqual(configuration.host, try XCTUnwrap(URL(string: hostString.apiSuffix().httpPrefix())))
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.last).isEnabled)
    }
    
    func testViewRequestedToContinueWithCorrectServerConfigurationCallCoordinator() throws {
        //Arrange
        let sut = self.buildSUT()
        let hostString = "www.example.com"
        sut.serverAddressDidChange(text: hostString)
        //Act
        sut.continueButtonTapped()
        self.serverConfigurationManagerMock.verifyParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.coordinatorMock.serverConfigurationDidFinishParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.last).isEnabled)
    }
    
    func testViewRequestedToContinueWithInvalidServerConfigurationGetsAnError() throws {
        //Arrange
        let sut = self.buildSUT()
        let hostString = "com"
        let url = try XCTUnwrap(URL(string: hostString))
        sut.serverAddressDidChange(text: hostString)
        //Act
        sut.continueButtonTapped()
        self.serverConfigurationManagerMock.verifyParams.last?.completion(.failure(ApiClientError(type: .invalidHost(url))))
        //Assert
        XCTAssertEqual(self.errorHandlerMock.throwingParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 3)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.last).isEnabled)
    }
}

// MARK: - serverAddressDidChange(text: String?)
extension ServerConfigurationViewModelTests {
    func testServerAddressDidChangePassedNilValue() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.serverAddressDidChange(text: nil)
        //Assert
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.first?.isEnabled))
    }
    
    func testServerAddressDidChangePassedEmptyStringValue() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.serverAddressDidChange(text: "")
        //Assert
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.first?.isEnabled))
    }
    
    func testServerAddressDidChangePassedCorrectHostName() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.serverAddressDidChange(text: "www.example.com")
        //Assert
        XCTAssertEqual(self.userInterfaceMock.continueButtonEnabledStateParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.continueButtonEnabledStateParams.last?.isEnabled))
    }
}

// MARK: - serverAddressTextFieldDidRequestForReturn() -> Bool
extension ServerConfigurationViewModelTests {
    func testServerAddressTextFieldDidRequestedForReturnDissmissKeyboard() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        _ = sut.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.dismissKeyboardParams.count, 1)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnReturnCorrectValue() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let value = sut.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
}

// MARK: - viewTapped()
extension ServerConfigurationViewModelTests {
    func testViewHasBeenTappedCallDissmissKeyboardOnUserInteface() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        _ = sut.viewTapped()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.dismissKeyboardParams.count, 1)
    }
}

// MARK: - Private
extension ServerConfigurationViewModelTests {
    private func buildSUT() -> ServerConfigurationViewModel {
        return ServerConfigurationViewModel(
            userInterface: self.userInterfaceMock,
            coordinator: self.coordinatorMock,
            serverConfigurationManager: self.serverConfigurationManagerMock,
            errorHandler: self.errorHandlerMock,
            notificationCenter: self.notificationCenterMock)
    }
}
