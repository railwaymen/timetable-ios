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
        XCTAssertTrue(self.userInterface.setupViewCalled)
        XCTAssertEqual(self.userInterface.setupViewStateValues.serverAddress, "")
        XCTAssertTrue(self.userInterface.setupViewStateValues.checkBoxIsActive)
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsNull() {
        //Act
        self.viewModel.viewRequestedToContinue()
        //Assert
        XCTAssertNil(self.userInterface.setActivityIndicatorIsHidden)
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
        XCTAssertNil(self.userInterface.setActivityIndicatorIsHidden)
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
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
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
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
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
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
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
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testServerAddressDidChangePassedNilValue() {
        //Act
        self.viewModel.serverAddressDidChange(text: nil)
        //Assert
        XCTAssertFalse(self.userInterface.continueButtonEnabledStateValues.called)
    }
    
    func testServerAddressDidChangePassedCorrectHostName() {
        //Act
        self.viewModel.serverAddressDidChange(text: "www.example.com")
        //Assert
        XCTAssertTrue(self.userInterface.continueButtonEnabledStateValues.called)
        XCTAssertTrue(self.userInterface.continueButtonEnabledStateValues.isEnabled)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnDissmissKeyboard() {
        //Act
        _ = self.viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(self.userInterface.dismissKeyboardCalled)
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
        XCTAssertTrue(self.userInterface.dismissKeyboardCalled)
    }
}
