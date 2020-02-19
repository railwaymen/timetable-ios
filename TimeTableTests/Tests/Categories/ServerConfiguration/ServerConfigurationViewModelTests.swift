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
    
    func testViewDidLoadCallSetupViewOnTheUserInterface() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.last?.serverAddress, "")
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setUpViewParams.last?.checkBoxIsActive))
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsNull() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.continueButtonTapped()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setActivityIndicatorParams.isEmpty)
        switch self.errorHandlerMock.throwingParams.last?.error as? UIError {
        case .cannotBeEmpty?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsInvalid() {
        //Arrange
        let sut = self.buildSUT()
        sut.serverAddressDidChange(text: "##invalid_address")
        //Act
        sut.continueButtonTapped()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setActivityIndicatorParams.isEmpty)
        switch self.errorHandlerMock.throwingParams.last?.error as? UIError {
        case .invalidFormat?: break
        default: XCTFail()
        }
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
        XCTAssertTrue(configuration.shouldRememberHost)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithStaySigneInAsFalse() throws {
        //Arrange
        let sut = self.buildSUT()
        let hostString = "www.example.com"
        sut.serverAddressDidChange(text: hostString)
        sut.checkboxButtonTapped(isActive: true)
        //Act
        sut.continueButtonTapped()
        self.serverConfigurationManagerMock.verifyParams.last?.completion(.success(Void()))
        //Assert
        let configuration = try XCTUnwrap(self.coordinatorMock.serverConfigurationDidFinishParams.last?.serverConfiguration)
        XCTAssertEqual(configuration.host, try XCTUnwrap(URL(string: hostString.apiSuffix().httpPrefix())))
        XCTAssertFalse(configuration.shouldRememberHost)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
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
    }
    
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
