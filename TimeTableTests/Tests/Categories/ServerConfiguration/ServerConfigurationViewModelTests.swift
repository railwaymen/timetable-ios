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
    private var userInterface: ServerConfigurationViewControllerMock!
    private var coordinatorMock: CoordinatorMock!
    private var serverConfigurationManagerMock: ServerConfigurationManagerMock!
    private var errorHandler: ErrorHandlerMock!
    
    override func setUp() {
        super.setUp()
        self.userInterface = ServerConfigurationViewControllerMock()
        self.errorHandler = ErrorHandlerMock()
        self.coordinatorMock = CoordinatorMock()
        self.serverConfigurationManagerMock = ServerConfigurationManagerMock()
    }
    
    func testViewDidLoadCallSetupViewOnTheUserInterface() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.setUpViewParams.count, 1)
        XCTAssertEqual(self.userInterface.setUpViewParams.last?.serverAddress, "")
        XCTAssertTrue(try (self.userInterface.setUpViewParams.last?.checkBoxIsActive).unwrap())
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsNull() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewRequestedToContinue()
        //Assert
        XCTAssertTrue(self.userInterface.setActivityIndicatorParams.isEmpty)
        switch self.errorHandler.throwingParams.last?.error as? UIError {
        case .cannotBeEmpty?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsInvalid() {
        //Arrange
        let sut = self.buildSUT()
        sut.serverAddressDidChange(text: "##invalid_address")
        //Act
        sut.viewRequestedToContinue()
        //Assert
        XCTAssertTrue(self.userInterface.setActivityIndicatorParams.isEmpty)
        switch self.errorHandler.throwingParams.last?.error as? UIError {
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
        sut.viewRequestedToContinue()
        self.serverConfigurationManagerMock.verifyParams.last?.completion(.success(Void()))
        //Assert
        let configuration = try (self.coordinatorMock.serverConfigurationDidFinishParams.last?.serverConfiguration).unwrap()
        XCTAssertEqual(configuration.host, try URL(string: hostString.apiSuffix().httpPrefix()).unwrap())
        XCTAssertTrue(configuration.shouldRememberHost)
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithStaySigneInAsFalse() throws {
        //Arrange
        let sut = self.buildSUT()
        let hostString = "www.example.com"
        sut.serverAddressDidChange(text: hostString)
        sut.shouldRemeberHostCheckBoxStatusDidChange(isActive: true)
        //Act
        sut.viewRequestedToContinue()
        self.serverConfigurationManagerMock.verifyParams.last?.completion(.success(Void()))
        //Assert
        let configuration = try (self.coordinatorMock.serverConfigurationDidFinishParams.last?.serverConfiguration).unwrap()
        XCTAssertEqual(configuration.host, try URL(string: hostString.apiSuffix().httpPrefix()).unwrap())
        XCTAssertFalse(configuration.shouldRememberHost)
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewRequestedToContinueWithCorrectServerConfigurationCallCoordinator() throws {
        //Arrange
        let sut = self.buildSUT()
        let hostString = "www.example.com"
        sut.serverAddressDidChange(text: hostString)
        //Act
        sut.viewRequestedToContinue()
        self.serverConfigurationManagerMock.verifyParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.coordinatorMock.serverConfigurationDidFinishParams.count, 1)
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewRequestedToContinueWithInvalidServerConfigurationGetsAnError() throws {
        //Arrange
        let sut = self.buildSUT()
        let hostString = "com"
        let url = try URL(string: hostString).unwrap()
        sut.serverAddressDidChange(text: hostString)
        //Act
        sut.viewRequestedToContinue()
        self.serverConfigurationManagerMock.verifyParams.last?.completion(.failure(ApiClientError(type: .invalidHost(url))))
        //Assert
        XCTAssertEqual(self.errorHandler.throwingParams.count, 1)
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testServerAddressDidChangePassedNilValue() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.serverAddressDidChange(text: nil)
        //Assert
        XCTAssertTrue(self.userInterface.continueButtonEnabledStateParams.isEmpty)
    }
    
    func testServerAddressDidChangePassedCorrectHostName() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.serverAddressDidChange(text: "www.example.com")
        //Assert
        XCTAssertEqual(self.userInterface.continueButtonEnabledStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.continueButtonEnabledStateParams.last?.isEnabled).unwrap())
    }
    
    func testServerAddressTextFieldDidRequestedForReturnDissmissKeyboard() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        _ = sut.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertEqual(self.userInterface.dismissKeyboardParams.count, 1)
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
        _ = sut.viewHasBeenTapped()
        //Assert
        XCTAssertEqual(self.userInterface.dismissKeyboardParams.count, 1)
    }
}

// MARK: - Private
extension ServerConfigurationViewModelTests {
    private func buildSUT() -> ServerConfigurationViewModel {
        return ServerConfigurationViewModel(
            userInterface: self.userInterface,
            coordinator: self.coordinatorMock,
            serverConfigurationManager: self.serverConfigurationManagerMock,
            errorHandler: self.errorHandler)
    }
}
