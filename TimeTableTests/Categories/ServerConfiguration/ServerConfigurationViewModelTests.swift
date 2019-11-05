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
    private var userInterface: UserInterfaceMock!
    private var coordinatorMock: CoordinatorMock!
    private var serverConfigurationManagerMock: ServerConfigurationManagerMock!
    private var errorHandler: ErrorHandlerMock!
    private var viewModel: ServerConfigurationViewModel!
    
    override func setUp() {
        userInterface = UserInterfaceMock()
        errorHandler = ErrorHandlerMock()
        coordinatorMock = CoordinatorMock()
        serverConfigurationManagerMock = ServerConfigurationManagerMock()
        viewModel = ServerConfigurationViewModel(userInterface: userInterface,
                                                 coordinator: coordinatorMock,
                                                 serverConfigurationManager: serverConfigurationManagerMock,
                                                 errorHandler: errorHandler)
        super.setUp()
    }
    
    func testViewDidLoadCallSetupViewOnTheUserInterface() {
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterface.setupViewCalled)
        XCTAssertEqual(userInterface.setupViewStateValues.serverAddress, "")
        XCTAssertTrue(userInterface.setupViewStateValues.checkBoxIsActive)
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsNull() {
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        XCTAssertNil(userInterface.setActivityIndicatorIsHidden)
        switch errorHandler.throwedError as? UIError {
        case .cannotBeEmpty?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsInvalid() {
        //Arrange
        viewModel.serverAddressDidChange(text: "##invalid_address")
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        XCTAssertNil(userInterface.setActivityIndicatorIsHidden)
        switch errorHandler.throwedError as? UIError {
        case .invalidFormat?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithDefaultValues() throws {
        //Arrange
        let hostString = "www.example.com"
        viewModel.serverAddressDidChange(text: hostString)
        //Act
        viewModel.viewRequestedToContinue()
        serverConfigurationManagerMock.verifyConfigurationCompletion?(.success(Void()))
        //Assert
        let configuration = try self.coordinatorMock.serverConfigurationDidFinishValues.serverConfiguration.unwrap()
        XCTAssertEqual(configuration.host, try URL(string: hostString.apiSuffix().httpPrefix()).unwrap())
        XCTAssertTrue(configuration.shouldRememberHost)
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithStaySigneInAsFalse() throws {
        //Arrange
        let hostString = "www.example.com"
        viewModel.serverAddressDidChange(text: hostString)
        viewModel.shouldRemeberHostCheckBoxStatusDidChange(isActive: true)
        //Act
        viewModel.viewRequestedToContinue()
        serverConfigurationManagerMock.verifyConfigurationCompletion?(.success(Void()))
        //Assert
        let configuration = try self.coordinatorMock.serverConfigurationDidFinishValues.serverConfiguration.unwrap()
        XCTAssertEqual(configuration.host, try URL(string: hostString.apiSuffix().httpPrefix()).unwrap())
        XCTAssertFalse(configuration.shouldRememberHost)
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewRequestedToContinueWithCorrectServerConfigurationCallCoordinator() throws {
        //Arrange
        let hostString = "www.example.com"
        viewModel.serverAddressDidChange(text: hostString)
        //Act
        viewModel.viewRequestedToContinue()
        serverConfigurationManagerMock.verifyConfigurationCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(self.coordinatorMock.serverConfigurationDidFinishValues.called)
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewRequestedToContinueWithInvalidServerConfigurationGetsAnError() throws {
        //Arrange
        let hostString = "com"
        let url = try URL(string: hostString).unwrap()
        viewModel.serverAddressDidChange(text: hostString)
        //Act
        viewModel.viewRequestedToContinue()
        serverConfigurationManagerMock.verifyConfigurationCompletion?(.failure(ApiClientError(type: .invalidHost(url))))
        //Assert
        XCTAssertNotNil(errorHandler.throwedError)
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testServerAddressDidChangePassedNilValue() {
        //Act
        viewModel.serverAddressDidChange(text: nil)
        //Assert
        XCTAssertFalse(userInterface.continueButtonEnabledStateValues.called)
    }
    
    func testServerAddressDidChangePassedCorrectHostName() {
        //Act
        viewModel.serverAddressDidChange(text: "www.example.com")
        //Assert
        XCTAssertTrue(userInterface.continueButtonEnabledStateValues.called)
        XCTAssertTrue(userInterface.continueButtonEnabledStateValues.isEnabled)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnDissmissKeyboard() {
        //Act
        _ = viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(userInterface.dismissKeyboardCalled)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnReturnCorrectValue() {
        //Act
        let value = viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testViewHasBeenTappedCallDissmissKeyboardOnUserInteface() {
        //Act
        _ = viewModel.viewHasBeenTapped()
        //Assert
        XCTAssertTrue(userInterface.dismissKeyboardCalled)
    }
}

private class UserInterfaceMock: ServerConfigurationViewModelOutput {
    private(set) var setupViewCalled = false
    private(set) var setupViewStateValues: (checkBoxIsActive: Bool, serverAddress: String) = (false, "")
    private(set) var dismissKeyboardCalled = false
    private(set) var continueButtonEnabledStateValues: (called: Bool, isEnabled: Bool) = (false, false)
    private(set) var checkBoxIsActiveStateValues: (called: Bool, isActive: Bool) = (false, false)
    private(set) var setActivityIndicatorIsHidden: Bool?
    
    func setupView(checkBoxIsActive: Bool, serverAddress: String) {
        setupViewCalled = true
        setupViewStateValues = (checkBoxIsActive, serverAddress)
    }
    
    func dismissKeyboard() {
        dismissKeyboardCalled = true
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        continueButtonEnabledStateValues = (true, isEnabled)
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        checkBoxIsActiveStateValues = (true, isActive)
    }
    
    func setActivityIndicator(isHidden: Bool) {
        setActivityIndicatorIsHidden = isHidden
    }
}
