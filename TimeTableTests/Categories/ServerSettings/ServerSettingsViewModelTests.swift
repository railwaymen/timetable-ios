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
    private var errorHandler: ErrorHandlerMock!
    
    override func setUp() {
        userInterface = UserInterfaceMock()
        errorHandler = ErrorHandlerMock()
        super.setUp()
    }
    
    func testViewDidLoadCallSetupViewOnTheUserInterface() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, errorHandler: errorHandler)
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterface.setupViewCalled)
    }
    
    func testViewWillDesappearCallTearDownOnTheUserInterface() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, errorHandler: errorHandler)
        //Act
        viewModel.viewWillDisappear()
        //Assert
        XCTAssertTrue(userInterface.tearDownCalled)
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsNull() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, errorHandler: errorHandler)
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
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, errorHandler: errorHandler)
        viewModel.serverAddressDidChange(text: "##invalid_address")
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        switch errorHandler.throwedError as? UIError {
        case .invalidFormat?: break
        default: XCTFail()
        }
    }
    
    /*TO_DO: viewRequestedToContinue - handle all cases */
    
    func testServerAddressDidChangePassedNilValue() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, errorHandler: errorHandler)
        //Act
        viewModel.serverAddressDidChange(text: nil)
        //Assert
        XCTAssertFalse(userInterface.continueButtonEnabledStateValues.called)
    }
    
    func testServerAddressDidChangePassedCorrectHostName() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, errorHandler: errorHandler)
        //Act
        viewModel.serverAddressDidChange(text: "www.example.com")
        //Assert
        XCTAssertTrue(userInterface.continueButtonEnabledStateValues.called)
        XCTAssertTrue(userInterface.continueButtonEnabledStateValues.isEnabled)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnDissmissKeyboard() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, errorHandler: errorHandler)
        //Act
        _ = viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(userInterface.dissmissKeyboardCalled)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnReturnCorrectValue() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, errorHandler: errorHandler)
        //Act
        let value = viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testViewHasBeenTappedCallDissmissKeyboardOnUserInteface() {
        //Arrange
        let viewModel = ServerSettingsViewModel(userInterface: userInterface, errorHandler: errorHandler)
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
    private(set) var setupViewCalled = false
    private(set) var tearDownCalled = false
    private(set) var dissmissKeyboardCalled = false
    private(set) var continueButtonEnabledStateValues: (called: Bool, isEnabled: Bool) = (false, false)
    
    func setupView() {
        setupViewCalled = true
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
}
