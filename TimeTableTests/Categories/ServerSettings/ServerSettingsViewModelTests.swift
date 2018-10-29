//
//  ServerSettingsViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ServerSettingsViewModelTests: XCTestCase {
 
    private var userInterface: UserInterfaceMock!
    private var coordinatorMock: CoordinatorMock!
    private var errorHandler: ErrorHandlerMock!
    
    override func setUp() {
        userInterface = UserInterfaceMock()
        errorHandler = ErrorHandlerMock()
        coordinatorMock = CoordinatorMock()
        super.setUp()
    }
    
    func testViewDidLoadCallSetupViewOnTheUserInterface() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterface.setupViewStateValues.called)
        XCTAssertTrue(userInterface.setupViewStateValues.checkBoxIsActive)
    }
    
    func testViewWillDesappearCallTearDownOnTheUserInterface() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        //Act
        viewModel.viewWillDisappear()
        //Assert
        XCTAssertTrue(userInterface.tearDownCalled)
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsNull() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        switch errorHandler.throwedError as? UIError {
        case .cannotBeEmpty?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsInvalid() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        viewModel.serverAddressDidChange(text: "##invalid_address")
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        switch errorHandler.throwedError as? UIError {
        case .invalidFormat?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithDefaultValues() throws {
        //Arrange
        let hostString = "www.example.com"
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        viewModel.serverAddressDidChange(text: hostString)
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        let configuration = try coordinatorMock.serverSettingsDidFinishValues.serverConfiguration.unwrap()
        XCTAssertEqual(configuration.host, try URL(string: hostString).unwrap())
        XCTAssertTrue(configuration.staySignedIn)
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithStaySigneInAsFalse() throws {
        //Arrange
        let hostString = "www.example.com"
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        viewModel.serverAddressDidChange(text: hostString)
        viewModel.staySinedInCheckBoxStatusDidChange(isActive: true)
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        let configuration = try coordinatorMock.serverSettingsDidFinishValues.serverConfiguration.unwrap()
        XCTAssertEqual(configuration.host, try URL(string: hostString).unwrap())
        XCTAssertFalse(configuration.staySignedIn)
    }
    
    func testViewRequestedToContinueWithCorrectServerConfigurationCallCoordinator() throws {
        //Arrange
        let hostString = "www.example.com"
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        viewModel.serverAddressDidChange(text: hostString)
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        XCTAssertTrue(coordinatorMock.serverSettingsDidFinishValues.called)
    }
    
    func testServerAddressDidChangePassedNilValue() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        //Act
        viewModel.serverAddressDidChange(text: nil)
        //Assert
        XCTAssertFalse(userInterface.continueButtonEnabledStateValues.called)
    }
    
    func testServerAddressDidChangePassedCorrectHostName() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        //Act
        viewModel.serverAddressDidChange(text: "www.example.com")
        //Assert
        XCTAssertTrue(userInterface.continueButtonEnabledStateValues.called)
        XCTAssertTrue(userInterface.continueButtonEnabledStateValues.isEnabled)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnDissmissKeyboard() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        //Act
        _ = viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(userInterface.dissmissKeyboardCalled)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnReturnCorrectValue() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        //Act
        let value = viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testViewHasBeenTappedCallDissmissKeyboardOnUserInteface() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, coordinator: coordinatorMock, errorHandler: errorHandler)
        //Act
        _ = viewModel.viewHasBeenTapped()
        //Assert
        XCTAssertTrue(userInterface.dissmissKeyboardCalled)
    }
}

private class ErrorHandlerMock: ErrorHandlerType {
    private(set) var throwedError: Error?
    private(set) var throwingFinallyBlock: ((Bool) -> Void)?
    private(set) var catchingErrorActionBlock: ((Error) throws -> Void)?
    
    func throwing(error: Error, finally: @escaping (Bool) -> Void) {
        throwedError = error
        throwingFinallyBlock = finally
    }
    
    func catchingError(action: @escaping (Error) throws -> Void) -> ErrorHandlerType {
        catchingErrorActionBlock = action
        return self
    }
}

private class UserInterfaceMock: ServerSettingsViewModelOutput {
    
    private(set) var setupViewStateValues: (called: Bool, checkBoxIsActive: Bool) = (false, false)
    private(set) var tearDownCalled = false
    private(set) var dissmissKeyboardCalled = false
    private(set) var continueButtonEnabledStateValues: (called: Bool, isEnabled: Bool) = (false, false)
    private(set) var checkBoxIsActiveStateValues: (called: Bool, isActive: Bool) = (false, false)
    
    func setupView(checkBoxIsActive: Bool) {
        setupViewStateValues = (true, checkBoxIsActive)
    }

    func tearDown() {
        tearDownCalled = true
    }
    
    func dissmissKeyboard() {
        dissmissKeyboardCalled = true
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        continueButtonEnabledStateValues = (true, isEnabled)
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        checkBoxIsActiveStateValues = (true, isActive)
    }
}

private class CoordinatorMock: ServerSettingsCoordinatorDelagete {
    private(set) var serverSettingsDidFinishValues: (called: Bool, serverConfiguration: ServerConfiguration?) = (false, nil)
    
    func serverSettingsDidFinish(with serverConfiguration: ServerConfiguration) {
        serverSettingsDidFinishValues = (true, serverConfiguration)
    }
}
