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
    private var viewModel: ServerConfigurationViewModel!
    
    override func setUp() {
        self.userInterface = ServerConfigurationViewControllerMock()
        self.errorHandler = ErrorHandlerMock()
        self.coordinatorMock = CoordinatorMock()
        self.serverConfigurationManagerMock = ServerConfigurationManagerMock()
        self.viewModel = ServerConfigurationViewModel(userInterface: self.userInterface,
                                                      coordinator: self.coordinatorMock,
                                                      serverConfigurationManager: self.serverConfigurationManagerMock,
                                                      errorHandler: self.errorHandler)
        super.setUp()
    }
    
    func testViewDidLoadCallSetupViewOnTheUserInterface() {
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.setUpViewParams.count, 1)
        XCTAssertEqual(self.userInterface.setUpViewParams.last?.serverAddress, "")
        XCTAssertTrue(try (self.userInterface.setUpViewParams.last?.checkBoxIsActive).unwrap())
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsNull() {
        //Act
        self.viewModel.viewRequestedToContinue()
        //Assert
        XCTAssertTrue(self.userInterface.setActivityIndicatorParams.isEmpty)
        switch self.errorHandler.throwedError as? UIError {
        case .cannotBeEmpty?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsInvalid() {
        //Arrange
        self.viewModel.serverAddressDidChange(text: "##invalid_address")
        //Act
        self.viewModel.viewRequestedToContinue()
        //Assert
        XCTAssertTrue(self.userInterface.setActivityIndicatorParams.isEmpty)
        switch self.errorHandler.throwedError as? UIError {
        case .invalidFormat?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithDefaultValues() throws {
        //Arrange
        let hostString = "www.example.com"
        self.viewModel.serverAddressDidChange(text: hostString)
        //Act
        self.viewModel.viewRequestedToContinue()
        self.serverConfigurationManagerMock.verifyConfigurationCompletion?(.success(Void()))
        //Assert
        let configuration = try self.coordinatorMock.serverConfigurationDidFinishValues.serverConfiguration.unwrap()
        XCTAssertEqual(configuration.host, try URL(string: hostString.apiSuffix().httpPrefix()).unwrap())
        XCTAssertTrue(configuration.shouldRememberHost)
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithStaySigneInAsFalse() throws {
        //Arrange
        let hostString = "www.example.com"
        self.viewModel.serverAddressDidChange(text: hostString)
        self.viewModel.shouldRemeberHostCheckBoxStatusDidChange(isActive: true)
        //Act
        self.viewModel.viewRequestedToContinue()
        self.serverConfigurationManagerMock.verifyConfigurationCompletion?(.success(Void()))
        //Assert
        let configuration = try self.coordinatorMock.serverConfigurationDidFinishValues.serverConfiguration.unwrap()
        XCTAssertEqual(configuration.host, try URL(string: hostString.apiSuffix().httpPrefix()).unwrap())
        XCTAssertFalse(configuration.shouldRememberHost)
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewRequestedToContinueWithCorrectServerConfigurationCallCoordinator() throws {
        //Arrange
        let hostString = "www.example.com"
        self.viewModel.serverAddressDidChange(text: hostString)
        //Act
        self.viewModel.viewRequestedToContinue()
        self.serverConfigurationManagerMock.verifyConfigurationCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(self.coordinatorMock.serverConfigurationDidFinishValues.called)
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewRequestedToContinueWithInvalidServerConfigurationGetsAnError() throws {
        //Arrange
        let hostString = "com"
        let url = try URL(string: hostString).unwrap()
        self.viewModel.serverAddressDidChange(text: hostString)
        //Act
        self.viewModel.viewRequestedToContinue()
        self.serverConfigurationManagerMock.verifyConfigurationCompletion?(.failure(ApiClientError(type: .invalidHost(url))))
        //Assert
        XCTAssertNotNil(self.errorHandler.throwedError)
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testServerAddressDidChangePassedNilValue() {
        //Act
        self.viewModel.serverAddressDidChange(text: nil)
        //Assert
        XCTAssertTrue(self.userInterface.continueButtonEnabledStateParams.isEmpty)
    }
    
    func testServerAddressDidChangePassedCorrectHostName() {
        //Act
        self.viewModel.serverAddressDidChange(text: "www.example.com")
        //Assert
        XCTAssertEqual(self.userInterface.continueButtonEnabledStateParams.count, 1)
        XCTAssertTrue(try (self.userInterface.continueButtonEnabledStateParams.last?.isEnabled).unwrap())
    }
    
    func testServerAddressTextFieldDidRequestedForReturnDissmissKeyboard() {
        //Act
        _ = self.viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertEqual(self.userInterface.dismissKeyboardParams.count, 1)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnReturnCorrectValue() {
        //Act
        let value = self.viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testViewHasBeenTappedCallDissmissKeyboardOnUserInteface() {
        //Act
        _ = self.viewModel.viewHasBeenTapped()
        //Assert
        XCTAssertEqual(self.userInterface.dismissKeyboardParams.count, 1)
    }
}
